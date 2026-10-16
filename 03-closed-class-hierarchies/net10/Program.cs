SessionState[] states = [new Proposed(), new Scheduled("Room A"), new Cancelled("Speaker unavailable")];

foreach (var state in states)
{
    Console.WriteLine(Describe(state));
}

static string Describe(SessionState state) => state switch
{
    Proposed => "Session: awaiting approval",
    Scheduled(var room) => $"Session: scheduled in {room}",
    Cancelled(var reason) => $"Session: cancelled ({reason})",
    _ => throw new InvalidOperationException("Unknown session state.")
};

public abstract record SessionState;
public sealed record Proposed : SessionState;
public sealed record Scheduled(string Room) : SessionState;
public sealed record Cancelled(string Reason) : SessionState;
