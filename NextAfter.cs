using System.Runtime.InteropServices;

Console.WriteLine(1f.NextAfter(-2f));
Console.WriteLine(1f.NextAfter( 2f));
Console.WriteLine(float.BitDecrement(1f));
Console.WriteLine(float.BitIncrement(1f));

public static class FloatExtensions
{
    public static float NextAfter(this float x, float y)
    {
        if (float.IsNaN(x) || float.IsNaN(y)) return x + y;
        if (x == y) return y;  // nextafter(0, -0) = -0

        Pun u = new(x);

        if (x == 0)
        {
            u.i = 1;
            return y > 0 ? u.f : -u.f;
        }

        if ((x > 0) == (y > x))
            u.i++;
        else
            u.i--;
        return u.f;
    }

    [StructLayout(LayoutKind.Explicit)]
    private struct Pun(float f)
    {
        [FieldOffset(0)] internal float f = f;
        [FieldOffset(0)] internal uint  i;
    }
}
