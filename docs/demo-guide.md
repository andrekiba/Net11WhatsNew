# Presenter guide

Run all commands below from the **repository root** in PowerShell.
This is a code-first walkthrough: keep each pair of `Program.cs` files open
side by side, then inspect the project files only when configuration matters.

## Prepare before presenting

1. Check `dotnet --version` reports `11.0.100-rc.2.26504.105`.
   Check `dotnet --list-runtimes` includes stable .NET 10 and the RC2 runtime.
2. Run `pwsh -NoProfile -File .\scripts\verify.ps1`.
   It builds all projects, checks results, and runs the diagnostic experiments
   on temporary copies without changing your working files.
3. Open [the index](../README.md) and the seven walkthroughs. Preview the two
   Mermaid diagrams in a Markdown viewer that supports them.
4. Set a readable terminal/editor font. Use the CLI if the editor's language
   service cannot understand C# 15 yet.
5. Keep Debug artifacts ready; the commands below intentionally skip restore
   and build. The programs require no network or external services.

Explain the baseline: one pinned .NET 11 SDK compiles both sets. The before
projects target .NET 10 with C# 14; the after projects target .NET 11 with C# 15.
The SDK/runtime is a release candidate. The selected language features are
available as C# 15 in RC2, while Runtime Async is still an opt-in preview.

## 01 - Runtime Async: same source, different execution machinery

Open [before](../01-runtime-async/net10/Program.cs) and
[after](../01-runtime-async/net11/Program.cs): the code is identical.
Show the opt-out in the before project and `runtime-async=on` in the after project.

```powershell
dotnet run --project .\01-runtime-async\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\01-runtime-async\net11 --configuration Debug --no-build --no-restore
```

Find the three application methods, then point to the builder frames that
disappear in the second run. Explain that completed awaits deliberately keep
the chain on the live stack. Do not claim a fixed frame count, automatic
speedup, or that exception stacks previously lacked cleanup.

**Transition:** start with a runtime improvement that requires no application
rewrite, then move to new ways to express domain models.

## 02 - Union types: choose one of these cases

Open the two [booking result implementations](../02-union-types/net11/README.md).
Show how the named union replaces the open base hierarchy and fallback, and
how its case records no longer inherit from a common result record.

```powershell
dotnet run --project .\02-union-types\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\02-union-types\net11 --configuration Debug --no-build --no-restore
```

Both print the reservation and sold-out result. Optionally remove the
`SoldOut` switch arm in the after file, then run:

```powershell
dotnet build .\02-union-types\net11 --no-restore
```

Show CS8509. **Undo the edit in the editor**, then run that build command again.
Do not run the intentionally incomplete switch. Avoid Git reset/checkout,
which could destroy unrelated local edits.

**Transition:** a union names alternatives; what if those alternatives really
belong to one inheritance hierarchy?

## 03 - Closed hierarchies: keep inheritance, close the direct descendants

Open the [session state pair](../03-closed-class-hierarchies/net11/README.md).
Show `closed` on the base record, sealed leaves, and the removed fallback.
Distinguish assembly-level direct derivation from file-level restrictions.

```powershell
dotnet run --project .\03-closed-class-hierarchies\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\03-closed-class-hierarchies\net11 --configuration Debug --no-build --no-restore
```

Optionally remove the `Cancelled` arm and build:

```powershell
dotnet build .\03-closed-class-hierarchies\net11 --no-restore
```

Show CS8509, **undo the edit in the editor**, and rebuild with the same command.
The leaves are sealed deliberately: `closed` on the parent does not transitively
seal every descendant.

**Transition:** move from domain modeling to everyday collection code.

## 04 - Collection arguments: preserve constructor intent inline

Open the [speaker submission pair](../04-collection-expression-arguments/net11/README.md).
Find capacity/comparer in the old constructors, then inside the leading
`with(...)` elements. The spread syntax alone is not new here.

```powershell
dotnet run --project .\04-collection-expression-arguments\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\04-collection-expression-arguments\net11 --configuration Debug --no-build --no-restore
```

Point to capacity 8, two unique speakers, and the successful lowercase lookup.
The behavior is preserved, including case-insensitive comparison.

## 05 - Extension indexers: a better call site, the same algorithm

Open the [session sequence pair](../05-extension-indexers/net11/README.md).
Point to the `IEnumerable<string>` receiver, compare `SessionAt(1)` with `[1]`,
and show the extension block's named receiver.

```powershell
dotnet run --project .\05-extension-indexers\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\05-extension-indexers\net11 --configuration Debug --no-build --no-restore
```

Both print `Second session: Union types`. The helper still calls `ElementAt`;
indexer syntax does not make enumeration constant-time.

## 06 - Labeled jumps: say which loop you mean

Open the [room scanning pair](../06-labeled-break-continue/net11/README.md).
Trace the old flags across nested loops, then show the label directly on the
outer `for`. Follow both `continue roomLoop` and `break roomLoop`.

```powershell
dotnet run --project .\06-labeled-break-continue\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\06-labeled-break-continue\net11 --configuration Debug --no-build --no-restore
```

Room 1 is skipped, room 2 ends the meetup, room 3 is never visited, and the
completion message still executes.

## 07 - Extended layout: a specialist interop feature

Open the [sensor reading pair](../07-extended-layout-support/net11/README.md).
Compare the explicit layout and per-field offsets with the CUnion layout.
Clarify that this is overlapping storage, **not** a type-safe union.

```powershell
dotnet run --project .\07-extended-layout-support\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\07-extended-layout-support\net11 --configuration Debug --no-build --no-restore
```

Both interpret `0x41200000` as `10.0`; reflection distinguishes ExplicitLayout
from ExtendedLayout. No native library is needed for this illustration, but
production ABI matching still requires platform-specific verification.

## Finish and restore the working state

The through-line is clearer intent: runtime-managed async execution, explicit
domain alternatives, concise construction, better extension syntax, direct
loop control, and explicit interop layout intent.

Ensure both manual switch-arm edits have been undone, then run:

```powershell
pwsh -NoProfile -File .\scripts\verify.ps1
git diff --check
```

If an SDK or runtime is missing, fix the prerequisite instead of silently
changing targets or preview versions. If the stack shape differs, return to
Debug and inspect the configuration rather than promising a particular number
of frames.

[Back to the index](../README.md)
