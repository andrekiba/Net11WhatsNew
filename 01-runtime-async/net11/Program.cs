using System.Diagnostics;
using System.Runtime.CompilerServices;

await LoadScheduleAsync();

[MethodImpl(MethodImplOptions.NoInlining)]
static async Task LoadScheduleAsync()
{
    await Task.CompletedTask;
    await LoadSessionAsync();
}

[MethodImpl(MethodImplOptions.NoInlining)]
static async Task LoadSessionAsync()
{
    await Task.CompletedTask;
    await ShowSpeakerAsync();
}

[MethodImpl(MethodImplOptions.NoInlining)]
static async Task ShowSpeakerAsync()
{
    await Task.CompletedTask;
    Console.WriteLine("Live stack:");
    Console.WriteLine(new StackTrace(fNeedFileInfo: false));
    Console.WriteLine("Schedule loaded.");
}
