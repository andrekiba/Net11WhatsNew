# 05 - Extension indexers

**Takeaway:** an extension block can add indexer syntax to a receiver whose
source type you do not own.

## Before and after

Read the second session title from a filtered `IEnumerable<string>`.
Compare [`net10/Program.cs`](../net10/Program.cs) with
[`net11/Program.cs`](Program.cs).

Before, a named extension method supplies `sessions.SessionAt(1)`.
After, the named receiver `sessions` inside an `extension(IEnumerable<string>
sessions)` block supports `public string this[int index]`. The caller writes
`sessions[1]`. Both implementations delegate to `ElementAt`.

The variable's static type is deliberately `IEnumerable<string>`, not an array
or list that already exposes the required indexer. Extension blocks themselves
arrived in C# 14; **extension indexers** are the C# 15 addition.

[Before project](../net10/ExtensionIndexersBefore.csproj) uses .NET 10 / C# 14;
[after project](ExtensionIndexersAfter.csproj) uses .NET 11 / C# 15.

## Run

From the **repository root**, after building the solution:

```powershell
dotnet run --project .\05-extension-indexers\net10 --configuration Debug --no-build --no-restore
dotnet run --project .\05-extension-indexers\net11 --configuration Debug --no-build --no-restore
```

Both print:

```text
Second session: Union types
```

## Show it live

1. Show that `IEnumerable<string>` does not declare an indexer.
2. Compare the helper declaration and call sites.
3. Point out that both bodies still call `ElementAt`: syntax changed, algorithm
   and validation behavior did not.

## Limitations

The receiver parameter must be named because this is an instance member.
Indexer syntax does not guarantee constant-time access: this filtered sequence
may be enumerated up to the requested element. Repeated indexing can therefore
be expensive. `ElementAt` still throws for invalid indices; the helper does not
swallow errors or return a misleading default.

Source: [Extension indexers](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/csharp-15#extension-indexers).

[Back to the demo index](../../README.md)
