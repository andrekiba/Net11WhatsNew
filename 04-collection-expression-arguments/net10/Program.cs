string[] submissions = ["Ada", "ADA", "Grace"];
var speakers = new List<string>(capacity: 8);
speakers.AddRange(submissions);
var uniqueSpeakers = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
uniqueSpeakers.UnionWith(submissions);

Console.WriteLine($"Submissions: {string.Join(", ", speakers)}");
Console.WriteLine($"Reserved capacity: {speakers.Capacity}");
Console.WriteLine($"Unique speakers: {uniqueSpeakers.Count}");
Console.WriteLine($"Contains 'grace': {uniqueSpeakers.Contains("grace")}");
