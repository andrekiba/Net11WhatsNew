string[] submissions = ["Ada", "ADA", "Grace"];
List<string> speakers = [with(capacity: 8), .. submissions];
HashSet<string> uniqueSpeakers = [with(StringComparer.OrdinalIgnoreCase), .. submissions];

Console.WriteLine($"Submissions: {string.Join(", ", speakers)}");
Console.WriteLine($"Reserved capacity: {speakers.Capacity}");
Console.WriteLine($"Unique speakers: {uniqueSpeakers.Count}");
Console.WriteLine($"Contains 'grace': {uniqueSpeakers.Contains("grace")}");
