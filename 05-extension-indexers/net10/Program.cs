IEnumerable<string> sessions = new[] { "Runtime Async", "Union types", "Closed hierarchies" }
    .Where(title => title.Length > 0);

Console.WriteLine($"Second session: {sessions.SessionAt(1)}");

public static class SessionSequenceExtensions
{
    public static string SessionAt(this IEnumerable<string> sessions, int index)
        => sessions.ElementAt(index);
}
