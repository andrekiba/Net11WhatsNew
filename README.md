# What's new in .NET 11 and C# 15

Seven independent **before/after console demos** for a meetup. Start with Runtime
Async, then explore C# 15. Each example contains `net10` (before) and `net11`
(after), with matching inputs and comparable results. No ASP.NET Core examples,
external services, or third-party packages are needed.

## Prerequisites

- **.NET 11 RC2 SDK `11.0.100-rc.2.26504.105`** and its
  **`11.0.0-rc.2.26504.105` runtime**.
- A stable **.NET 10 runtime** (`10.0.x`) to run the before projects.
  Installing the .NET 10 SDK also supplies that runtime.
- **PowerShell 7+** for `scripts\verify.ps1`. An editor with C# 15 support is
  helpful, but the CLI is sufficient.

Get the SDKs from the [.NET downloads](https://dotnet.microsoft.com/download/dotnet).
`global.json` pins the exact RC2 SDK and disables roll-forward, so a different
.NET 11 preview or a later stable SDK will not silently change the demo.
The SDK compiles **both** targets; installing a separate .NET 10 SDK is not
required for compilation.

```powershell
dotnet --list-sdks
dotnet --list-runtimes
dotnet --version
```

The last command must print `11.0.100-rc.2.26504.105` when run in this repository.
Keep .NET 10 and .NET 11 installed side by side. These are prerelease .NET 11
examples, not a production migration guide. C# 15 language features used here
work with `LangVersion` set to `15.0` on RC2; Runtime Async remains an opt-in
runtime preview. No blanket `LangVersion=preview` is necessary.

## Demo order

| # | Area | Feature and walkthrough |
| --- | --- | --- |
| 01 | .NET runtime | [Runtime Async](01-runtime-async/net11/README.md) |
| 02 | C# 15 | [Union types](02-union-types/net11/README.md) |
| 03 | C# 15 | [Closed class hierarchies](03-closed-class-hierarchies/net11/README.md) |
| 04 | C# 15 | [Collection expression arguments](04-collection-expression-arguments/net11/README.md) |
| 05 | C# 15 | [Extension indexers](05-extension-indexers/net11/README.md) |
| 06 | C# 15 | [Labeled break and continue](06-labeled-break-continue/net11/README.md) |
| 07 | Compiler/runtime interop | [Extended layout support](07-extended-layout-support/net11/README.md) |

Use the [presenter's guide](docs/demo-guide.md) for the full live-demo sequence.

## Build and run

Run these commands **from the repository root**:

```powershell
dotnet build .\Net11WhatsNew.slnx --configuration Debug
dotnet run --project .\01-runtime-async\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\01-runtime-async\net11 --configuration Debug --no-build --no-restore
```

For any other example, replace `01-runtime-async` with its folder name. Each
project can also be built and run independently: omit `--no-build --no-restore`
for the first run. Keep Debug for the Runtime Async stack comparison.

```text
01-runtime-async\
  net10\                 Before: .NET 10 / C# 14
    Program.cs
    RuntimeAsyncBefore.csproj
  net11\                 After: .NET 11 / C# 15
    Program.cs
    RuntimeAsyncAfter.csproj
    README.md            Explanation, commands, output, limitations
```

The other six examples follow the same layout. Compare the two `Program.cs`
files and their project files side by side. Feature-specific configuration stays
in the project that needs it; there is no shared demo framework hiding the code.

## Verify everything

```powershell
pwsh -NoProfile -File .\scripts\verify.ps1
```

The script checks SDK/runtime prerequisites, builds the solution in Debug with
warnings treated as errors, and runs all fourteen projects. It checks actual
expected outputs, the Runtime Async stack structure, and layout metadata.
It also removes a switch arm in **temporary copies** of the union and closed
examples, confirms diagnostic `CS8509`, and deletes those copies. Your source
files are not modified.

Build/restore once before presenting. There are no external package references
or network calls in the programs. The documented `--no-build --no-restore` runs
use the prepared local artifacts without contacting services. Initial restore
can still need access to configured NuGet feeds if targeting packs are missing.

## Troubleshooting

| Symptom | Action |
| --- | --- |
| SDK not found / incompatible SDK | Install the exact RC2 SDK pinned in `global.json`; check `dotnet --list-sdks` and the `dotnet` executable on your PATH. |
| Runtime missing when running `net10` | Install a stable .NET 10 runtime; do not roll the example forward to .NET 11. |
| Editor marks new syntax as invalid, CLI builds succeed | Update the editor/C# tooling to support the RC2 compiler, or use the CLI during the demo. |
| Runtime Async stack looks different | Use Debug and the unchanged project files; compare application methods and builder infrastructure, not exact frame counts or line numbers. |
| Verification reports `CS8509` in your source | Restore the switch arm removed during the manual experiment before continuing. |

The examples were exercised on Windows x64. .NET 11 has updated CPU/platform
requirements; consult the [runtime release notes](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-11/runtime).
The layout example uses two primitive 32-bit fields and no native dependency;
it does not establish compatibility with an arbitrary native ABI.

## Inspiration and sources

The paired-example organization and selection of topics are inspired by
[edandersen/dotnet-11-whats-new](https://github.com/edandersen/dotnet-11-whats-new).
The implementations and walkthroughs here are original; upstream code, text,
and images are not reproduced.

Feature details are grounded in the
[C# 15 overview](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-15),
[RC1 C# release notes](https://github.com/dotnet/core/blob/main/release-notes/11.0/preview/rc1/csharp.md),
[RC2 C# release notes](https://github.com/dotnet/core/blob/main/release-notes/11.0/preview/rc2/csharp.md),
and [.NET 11 runtime notes](https://learn.microsoft.com/en-us/dotnet/core/whats-new/dotnet-11/runtime).
Each walkthrough links to its specific reference.
