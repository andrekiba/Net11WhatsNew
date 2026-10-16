# 03 - Closed class hierarchies

**Takeaway:** when the domain really is an inheritance hierarchy, `closed`
restricts direct derivation to the declaring assembly and enables exhaustive
matching over known descendants.

## Before and after

A meetup session can be proposed, scheduled, or cancelled.
Compare [`net10/Program.cs`](../net10/Program.cs) with
[`net11/Program.cs`](Program.cs).

Before, an abstract `SessionState` record requires a fallback when matched.
After, `public closed record SessionState;` is implicitly abstract, and
the switch covers the three known descendants with no fallback. The leaf
records remain sealed.

Unlike the preceding union example, these cases **inherit** from the base type.
Do not combine `closed` with an explicit `abstract` modifier.

[Before project](../net10/ClosedHierarchiesBefore.csproj) uses .NET 10 / C# 14;
[after project](ClosedHierarchiesAfter.csproj) uses .NET 11 / C# 15.

## Run

From the **repository root**, after building the solution:

```powershell
dotnet run --project .\03-closed-class-hierarchies\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\03-closed-class-hierarchies\net11 --configuration Debug --no-build --no-restore
```

Both print:

```text
Session: awaiting approval
Session: scheduled in Room A
Session: cancelled (Speaker unavailable)
```

## Show it live

1. Compare `abstract` plus fallback with `closed` plus explicit descendant cases.
2. Note that adding another descendant in this assembly would require reviewing
   the switch.
3. Temporarily remove the `Cancelled` switch arm in `net11\Program.cs`.
4. Run `dotnet build .\03-closed-class-hierarchies\net11 --no-restore` from the
   root and show warning **CS8509**.
5. Undo the edit in the editor and rebuild before continuing.

The verification script checks the missing-arm diagnostic in a temporary copy.

## Limitations

The restriction is to the **declaring assembly**, not the same file. It applies
to direct descendants: an unsealed, non-closed child can still be extended
elsewhere. Sealed leaves here keep the model simple; intermediate closed
classes are an option for deeper hierarchies. This does not perform runtime
validation of arbitrary external state.

Sources: [Closed hierarchies overview](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-15#closed-hierarchies),
[`closed` reference](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/keywords/closed).

[Back to the demo index](../../README.md)
