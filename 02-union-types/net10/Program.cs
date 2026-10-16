BookingResult[] results = [new Reserved("C15", 12), new SoldOut("RUNTIME")];

foreach (var result in results)
{
    Console.WriteLine(Describe(result));
}

static string Describe(BookingResult result) => result switch
{
    Reserved(var session, var seat) => $"Reserved: {session}, seat {seat}",
    SoldOut(var session) => $"Sold out: {session}",
    _ => throw new InvalidOperationException("Unknown booking result.")
};

public abstract record BookingResult;
public sealed record Reserved(string Session, int Seat) : BookingResult;
public sealed record SoldOut(string Session) : BookingResult;
