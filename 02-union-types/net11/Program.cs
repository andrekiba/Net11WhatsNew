BookingResult[] results = [new Reserved("C15", 12), new SoldOut("RUNTIME")];

foreach (var result in results)
{
    Console.WriteLine(Describe(result));
}

static string Describe(BookingResult result) => result switch
{
    Reserved(var session, var seat) => $"Reserved: {session}, seat {seat}",
    SoldOut(var session) => $"Sold out: {session}",
};

public record Reserved(string Session, int Seat);
public record SoldOut(string Session);
public union BookingResult(Reserved, SoldOut);
