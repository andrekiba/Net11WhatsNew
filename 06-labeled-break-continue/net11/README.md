# 06 - Labeled break and continue

**Takeaway:** name an enclosing loop to direct a `break` or `continue` out of a
nested loop without propagating flags.

## Before and after

Scan the meetup's room schedules. A closed room skips its remaining slots; an
ended meetup stops scanning all rooms.
Compare [`net10/Program.cs`](../net10/Program.cs) and
[`net11/Program.cs`](Program.cs).

Before, the inner loop sets `roomClosed` or `meetupEnded` before breaking.
The outer loop then interprets these flags.
After, `roomLoop:` labels the outer loop directly. `continue roomLoop;` skips
the rest of the room, while `break roomLoop;` ends the whole scan.

[Before project](../net10/LabeledLoopsBefore.csproj) uses .NET 10 / C# 14;
[after project](LabeledLoopsAfter.csproj) uses .NET 11 / C# 15.

## Run

From the **repository root**, after building the solution:

```powershell
dotnet run --project .\06-labeled-break-continue\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\06-labeled-break-continue\net11 --configuration Debug --no-build --no-restore
```

Both print:

```text
Room 1: Welcome
Room 1: skip remaining slots
Room 2: C# 15
Meetup ended: stop all rooms
Schedule scan complete.
```

## Show it live

1. Trace both flags from the inner loop to the outer loop.
2. Replace that mental bookkeeping with the two named jumps.
3. Run both versions: neither prints `Skipped talk`, `Skipped Q&A`, or
   `Never visited`. Both still execute the final completion message.

## Limitations

The label goes **directly on** its enclosing loop or switch, not an arbitrary
statement. Labeled `break` can target a loop or switch; labeled `continue`
targets a loop. Ordinary unlabeled jumps keep their existing innermost-target
behavior. Use descriptive labels only when they clarify nested control flow,
not as an excuse for unnecessary nesting.

Sources: [C# 15 labeled jumps](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-15#labeled-break-and-continue),
[Jump statement reference](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/statements/jump-statements).

[Back to the demo index](../../README.md)
