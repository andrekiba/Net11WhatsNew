# 04 - Collection expression arguments

**Takeaway:** collection expressions can now supply arguments to the underlying
constructor or factory through a leading `with(...)` element.

## Before and after

Collect speaker submissions while reserving spare capacity, and deduplicate
speaker names case-insensitively.
Compare [`net10/Program.cs`](../net10/Program.cs) with
[`net11/Program.cs`](Program.cs).

Before, constructors select capacity/comparer and separate calls add items.
After, the first element of the expression supplies those arguments:

```csharp
List<string> speakers = [with(capacity: 8), .. submissions];
HashSet<string> uniqueSpeakers = [with(StringComparer.OrdinalIgnoreCase), .. submissions];
```

The novelty is **constructor arguments**, not collection expressions or spread
elements themselves; the before code already uses an ordinary array collection
expression. The target collection type remains explicit.

[Before project](../net10/CollectionArgumentsBefore.csproj) uses .NET 10 / C# 14;
[after project](CollectionArgumentsAfter.csproj) uses .NET 11 / C# 15.

## Run

From the **repository root**, after building the solution:

```powershell
dotnet run --project .\04-collection-expression-arguments\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\04-collection-expression-arguments\net11 --configuration Debug --no-build --no-restore
```

Both print:

```text
Submissions: Ada, ADA, Grace
Reserved capacity: 8
Unique speakers: 2
Contains 'grace': True
```

## Show it live

1. Point to the old constructor arguments and the separate population calls.
2. Find the same arguments inside the two leading `with(...)` elements.
3. Compare output: capacity is preserved, and both `ADA` and `grace` demonstrate
   why the comparer is behavioral, not just cosmetic.

## Limitations

`with(...)` must be the first element and its arguments must be valid for the
target collection's supported construction path. It is not a record `with`
expression. Choosing capacity or a comparer remains a domain decision; the
feature does not automatically choose an optimal capacity or change collection
semantics.

Source: [Collection expression arguments](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-15#collection-expression-arguments).

[Back to the demo index](../../README.md)
