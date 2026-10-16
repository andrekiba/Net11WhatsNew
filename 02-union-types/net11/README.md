# 02 - Union types

**Takeaway:** represent a value with an explicit set of possible case types,
without requiring those types to inherit from one application base class.

## Before and after

The meetup booking operation returns either a reservation or a sold-out result.
Compare [`net10/Program.cs`](../net10/Program.cs) and
[`net11/Program.cs`](Program.cs).

Before, `BookingResult` is an abstract record with sealed descendants. Its
`switch` has a throwing fallback because the base hierarchy is open.
After, `public union BookingResult(Reserved, SoldOut);` names the allowed
case types. Those records do not inherit from `BookingResult`: implicit
conversions let us place their values into a `BookingResult[]`.
The switch covers both cases without a fallback.

[Before project](../net10/UnionTypesBefore.csproj) uses .NET 10 / C# 14;
[after project](UnionTypesAfter.csproj) uses .NET 11 / C# 15, without additional
preview flags on RC2.

## Run

From the **repository root**, after building the solution:

```powershell
dotnet run --project .\02-union-types\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\02-union-types\net11 --configuration Debug --no-build --no-restore
```

Both print:

```text
Reserved: C15, seat 12
Sold out: RUNTIME
```

## Show it live

1. Compare the open base type and fallback with the explicit union declaration.
2. Show the case types no longer inherit from the result.
3. In `net11\Program.cs`, temporarily remove the entire `SoldOut` switch arm.
4. Run `dotnet build .\02-union-types\net11 --no-restore` from the root:
   RC2 reports **CS8509**, a non-exhaustive switch warning.
5. Undo that edit in the editor, then rebuild before running again.

`scripts\verify.ps1` performs this experiment on a temporary copy and promotes
CS8509 to an error. The committed example remains complete and warning-free.

## Limitations

This example focuses on non-null booking results and matching every declared
case. Exhaustiveness is a compiler diagnostic, not a replacement for input
validation. A union is not simply a shorter abstract-class declaration, nor is
it a C-style memory-overlay union. Compare the next example for a hierarchy
whose cases really are derived types.

Sources: [Union types overview](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-15#union-types),
[RC1 stabilization](https://github.com/dotnet/core/blob/main/release-notes/11.0/preview/rc1/csharp.md#c-15-stabilizes-unions-and-other-language-features).

[Back to the demo index](../../README.md)
