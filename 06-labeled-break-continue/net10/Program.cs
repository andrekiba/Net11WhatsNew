string[][] rooms =
[
    ["Welcome", "ROOM CLOSED", "Skipped talk"],
    ["C# 15", "MEETUP ENDED", "Skipped Q&A"],
    ["Never visited"]
];

bool meetupEnded = false;
for (int room = 0; room < rooms.Length; room++)
{
    bool roomClosed = false;
    foreach (string slot in rooms[room])
    {
        if (slot == "ROOM CLOSED")
        {
            Console.WriteLine($"Room {room + 1}: skip remaining slots");
            roomClosed = true;
            break;
        }

        if (slot == "MEETUP ENDED")
        {
            Console.WriteLine("Meetup ended: stop all rooms");
            meetupEnded = true;
            break;
        }

        Console.WriteLine($"Room {room + 1}: {slot}");
    }

    if (meetupEnded)
        break;
    if (roomClosed)
        continue;

    Console.WriteLine($"Room {room + 1}: all slots completed");
}

Console.WriteLine("Schedule scan complete.");
