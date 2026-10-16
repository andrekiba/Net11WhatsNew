#Requires -Version 7.0
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot

function Invoke-Dotnet {
    param(
        [Parameter(Mandatory)][string[]] $Arguments,
        [switch] $AllowFailure
    )

    $output = & dotnet @Arguments 2>&1
    $code = $LASTEXITCODE
    $text = ($output | ForEach-Object { "$_" }) -join "`n"
    if ($code -ne 0 -and -not $AllowFailure) {
        throw "dotnet $($Arguments -join ' ') failed (exit $code).`n$text"
    }
    [pscustomobject]@{ ExitCode = $code; Text = $text.Trim() }
}

function Assert-Equal {
    param([string] $Actual, [string] $Expected, [string] $Context)
    if ($Actual -cne $Expected) {
        throw "${Context}: unexpected output.`nExpected:`n$Expected`nActual:`n$Actual"
    }
}

$examples = @(
    @{ Folder = '01-runtime-async' },
    @{
        Folder = '02-union-types'
        Expected = @('Reserved: C15, seat 12', 'Sold out: RUNTIME')
        RemoveArm = '    SoldOut(var session) =>'
    },
    @{
        Folder = '03-closed-class-hierarchies'
        Expected = @('Session: awaiting approval', 'Session: scheduled in Room A', 'Session: cancelled (Speaker unavailable)')
        RemoveArm = '    Cancelled(var reason) =>'
    },
    @{
        Folder = '04-collection-expression-arguments'
        Expected = @('Submissions: Ada, ADA, Grace', 'Reserved capacity: 8', 'Unique speakers: 2', "Contains 'grace': True")
    },
    @{
        Folder = '05-extension-indexers'
        Expected = @('Second session: Union types')
    },
    @{
        Folder = '06-labeled-break-continue'
        Expected = @('Room 1: Welcome', 'Room 1: skip remaining slots', 'Room 2: C# 15', 'Meetup ended: stop all rooms', 'Schedule scan complete.')
    },
    @{ Folder = '07-extended-layout-support' }
)

Push-Location $root
try {
    $sdk = (Get-Content -LiteralPath '.\global.json' -Raw | ConvertFrom-Json).sdk.version
    $installed = (Invoke-Dotnet -Arguments @('--list-sdks')).Text
    if ($installed -notmatch "(?m)^$([regex]::Escape($sdk)) ") {
        throw "Required SDK $sdk is missing. See README.md."
    }
    Assert-Equal (Invoke-Dotnet -Arguments @('--version')).Text $sdk 'SDK selection'

    $runtimes = (Invoke-Dotnet -Arguments @('--list-runtimes')).Text
    foreach ($version in @('10\.0\.\d+', '11\.0\.0-rc\.2\.26504\.105')) {
        if ($runtimes -notmatch "(?m)^Microsoft\.NETCore\.App $version ") {
            throw "Required runtime $version is missing. See README.md."
        }
    }

    $build = Invoke-Dotnet -Arguments @('build', 'Net11WhatsNew.slnx', '--configuration', 'Debug', '--nologo', '--verbosity', 'quiet', '-warnaserror')
    Write-Host 'Solution build passed.'

    foreach ($example in $examples) {
        $outputs = @{}
        foreach ($target in @('net10', 'net11')) {
            $directory = Join-Path $root "$($example.Folder)\$target"
            $projects = @(Get-ChildItem -LiteralPath $directory -Filter '*.csproj')
            if ($projects.Count -ne 1) {
                throw "$directory must contain exactly one project."
            }
            $outputs[$target] = (Invoke-Dotnet -Arguments @(
                'run', '--project', $projects[0].FullName, '--configuration', 'Debug', '--no-build', '--no-restore'
            )).Text
        }

        switch ($example.Folder) {
            '01-runtime-async' {
                foreach ($target in @('net10', 'net11')) {
                    foreach ($marker in @('Live stack:', 'LoadScheduleAsync', 'LoadSessionAsync', 'ShowSpeakerAsync', 'Schedule loaded.')) {
                        if (-not $outputs[$target].Contains($marker)) {
                            throw "Runtime Async ($target): missing '$marker'.`n$($outputs[$target])"
                        }
                    }
                }
                if ($outputs.net10 -notmatch 'AsyncMethodBuilderCore\.Start') {
                    throw "Runtime Async baseline did not expose compiler state-machine infrastructure.`n$($outputs.net10)"
                }
                if ($outputs.net11 -match 'AsyncMethodBuilderCore\.Start') {
                    throw "Runtime Async still exposes compiler state-machine infrastructure.`n$($outputs.net11)"
                }
            }
            '07-extended-layout-support' {
                $common = "Raw bits: 0x41200000`nSensor value: 10.0`nLayout: "
                Assert-Equal $outputs.net10 ($common + 'ExplicitLayout') "$($example.Folder) net10"
                Assert-Equal $outputs.net11 ($common + 'ExtendedLayout') "$($example.Folder) net11"
            }
            default {
                $expected = $example.Expected -join "`n"
                Assert-Equal $outputs.net10 $expected "$($example.Folder) net10"
                Assert-Equal $outputs.net11 $expected "$($example.Folder) net11"
            }
        }
        Write-Host "$($example.Folder): both projects passed."
    }

    $temporary = Join-Path ([IO.Path]::GetTempPath()) "Net11WhatsNew-$([guid]::NewGuid().ToString('N'))"
    New-Item -ItemType Directory -Path $temporary | Out-Null
    try {
        Copy-Item -LiteralPath '.\global.json' -Destination $temporary
        foreach ($example in $examples | Where-Object { $_.ContainsKey('RemoveArm') }) {
            $source = Join-Path $root "$($example.Folder)\net11"
            $destination = Join-Path $temporary $example.Folder
            New-Item -ItemType Directory -Path $destination | Out-Null
            $project = Get-ChildItem -LiteralPath $source -Filter '*.csproj'
            Copy-Item -LiteralPath $project.FullName -Destination $destination
            $lines = Get-Content -LiteralPath (Join-Path $source 'Program.cs')
            $removed = @($lines | Where-Object { $_.StartsWith($example.RemoveArm, [StringComparison]::Ordinal) })
            if ($removed.Count -ne 1) {
                throw "$($example.Folder): expected exactly one switch arm to remove."
            }
            $lines | Where-Object { -not $_.StartsWith($example.RemoveArm, [StringComparison]::Ordinal) } |
                Set-Content -LiteralPath (Join-Path $destination 'Program.cs') -Encoding utf8
            $result = Invoke-Dotnet -AllowFailure -Arguments @(
                'build', (Join-Path $destination $project.Name), '--nologo', '--verbosity', 'quiet', '-warnaserror:CS8509'
            )
            if ($result.ExitCode -eq 0 -or $result.Text -notmatch 'error CS8509\b') {
                throw "$($example.Folder): expected non-exhaustive switch diagnostic CS8509.`n$($result.Text)"
            }
            Write-Host "$($example.Folder): missing-case diagnostic CS8509 verified on a temporary copy."
        }
    }
    finally {
        Remove-Item -LiteralPath $temporary -Recurse -Force
    }

    Write-Host 'All 14 projects and both diagnostic experiments passed.'
}
finally {
    Pop-Location
}
