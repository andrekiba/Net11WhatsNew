string[][] rooms =
[
    ["Welcome", "ROOM CLOSED", "Skipped talk"],
    ["C# 15", "MEETUP ENDED", "Skipped Q&A"],
    ["Never visited"]
];

roomLoop: for (int room = 0; room < rooms.Length; room++)
{
    foreach (string slot in rooms[room])
    {
        if (slot == "ROOM CLOSED")
        {
            Console.WriteLine($"Room {room + 1}: skip remaining slots");
            continue roomLoop;
        }

        if (slot == "MEETUP ENDED")
        {
            Console.WriteLine("Meetup ended: stop all rooms");
            break roomLoop;
        }

        Console.WriteLine($"Room {room + 1}: {slot}");
    }

    Console.WriteLine($"Room {room + 1}: all slots completed");
}

Console.WriteLine("Schedule scan complete.");
