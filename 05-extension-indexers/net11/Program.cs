IEnumerable<string> sessions = new[] { "Runtime Async", "Union types", "Closed hierarchies" }
    .Where(title => title.Length > 0);

Console.WriteLine($"Second session: {sessions[1]}");

public static class SessionSequenceExtensions
{
    extension(IEnumerable<string> sessions)
    {
        public string this[int index] => sessions.ElementAt(index);
    }
}
