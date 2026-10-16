using System.Globalization;
using System.Reflection;
using System.Runtime.InteropServices;

var reading = new SensorReading { Bits = 0x41200000 };
Console.WriteLine($"Raw bits: 0x{reading.Bits:X8}");
Console.WriteLine($"Sensor value: {reading.Value.ToString("F1", CultureInfo.InvariantCulture)}");
Console.WriteLine($"Layout: {typeof(SensorReading).Attributes & TypeAttributes.LayoutMask}");

[ExtendedLayout(ExtendedLayoutKind.CUnion)]
public struct SensorReading
{
    public int Bits;
    public float Value;
}
