.MCO
.TAB 1

using System.Collections;

double weight = 175;
double mass = weight / Planet.Earth.SurfaceGravity();

foreach (Planet p in Planet.All)
{
    Console.WriteLine($"Weight on {p} is {p.SurfaceWeight(mass)}");
}

public struct Planet : IEnumerable<Planet>
{
    private static readonly Dictionary<int, double> Masses   = new();
    private static readonly Dictionary<int, double> Radiuses = new();
    private static readonly Dictionary<int, string> Names    = new();

    private readonly int flag;

    public readonly double Mass => Masses[flag];
    public readonly double Radius => Radiuses[flag];

    public static int Count { get; private set; } = 0;

    public static readonly Planet None    = new(0);
    public static readonly Planet Mercury = new(3.303e+23, 2.4397e6);
    public static readonly Planet Venus   = new(4.869e+24, 6.0518e6);
    public static readonly Planet Earth   = new(5.976e+24, 6.37814e6);
    public static readonly Planet Mars    = new(6.421e+23, 3.3972e6);
    public static readonly Planet Jupiter = new(1.9e+27,   7.1492e7);
    public static readonly Planet Saturn  = new(5.688e+26, 6.0268e7);
    public static readonly Planet Uranus  = new(8.686e+25, 2.5559e7);
    public static readonly Planet Neptune = new(1.024e+26, 2.4746e7);
    public static readonly Planet Pluto   = new(1.27e+22,  1.137e6);
    public static readonly Planet Last    = new(1 << (Count - 1));
    public static readonly Planet All     = new((int)~((~0U) << Count));

    private Planet(int value)
    {
        flag = value;
    }
.MCR
.TAB 2
    private Planet(double mass, double radius,
        [System.Runtime.CompilerServices.CallerMemberName]
        string field = ""
    ) {
        flag = 1 << Count++;

        Masses[flag] = mass;
        Radiuses[flag] = radius;
        Names[flag] = field;
    }

    public static implicit operator int(Planet feature)
        => feature.flag;
    public static implicit operator Planet(int value)
        => new(value);

    // Universal gravitational constant (m^3 kg^-1 s^-2).
    const double G = 6.67300E-11;

    public readonly double SurfaceGravity()
    {
        return G * Mass / (Radius * Radius);
    }      

    public readonly double SurfaceWeight(double otherMass)
    {
        return otherMass * SurfaceGravity();
    }

    public readonly IEnumerator<Planet> GetEnumerator()
    {
        for (Planet j = flag; j != 0; j &= j - 1)
        {
            yield return j & (-j);
        }
    }

    readonly IEnumerator IEnumerable.GetEnumerator()
    {
        return GetEnumerator();
    }

    public override readonly string ToString() => Names[flag];
}
.MCX 0
.TQ
