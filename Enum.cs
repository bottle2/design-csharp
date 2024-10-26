



double weight = 175;
double mass = weight / Planet.Earth.SurfaceGravity();

foreach (Planet p in Enum.GetValues(typeof(Planet)))
    Console.WriteLine(
        $"Weight on {p} is {p.SurfaceWeight(mass)}");

enum Planet
{
    Mercury,
    Venus,
    Earth,
    Mars,
    Jupiter,
    Saturn,
    Uranus,
    Neptune,
    Pluto,
    PlanetX
}

static class PlanetExtensions
{
    // In kilograms.
    public static double Mass(this Planet p) => p switch
    {
        Planet.Mercury => 3.303E+23,
        Planet.Venus => 4.869E+24,
        Planet.Earth => 5.976E+24,
        Planet.Mars => 6.421E+23,
        Planet.Jupiter => 1.9E+27,
        Planet.Saturn => 5.688E+26,
        Planet.Uranus => 8.686E+25,
        Planet.Neptune => 1.024E+26,
        Planet.Pluto => 1.27E+22,
        _ => throw new ArgumentOutOfRangeException(nameof(p)),
    };

    // In meters.
    public static double Radius(this Planet p) => p switch
    {
        Planet.Mercury => 2439700,
        Planet.Venus => 6051800,
        Planet.Earth => 6378140,
        Planet.Mars => 3397200,
        Planet.Jupiter => 71492000,
        Planet.Saturn => 60268000,
        Planet.Uranus => 25559000,
        Planet.Neptune => 24746000,
        Planet.Pluto => 1137000,
        _ => throw new ArgumentOutOfRangeException(nameof(p)),
    };

    // Universal gravitational constant (m^3 kg^-1 s^-2).
    const double G = 6.67300E-11;

    public static double SurfaceGravity(this Planet p)
    {
        return G * p.Mass() / (p.Radius() * p.Radius());
    }      

    public static double SurfaceWeight(
            this Planet p, double otherMass)
    {
        return otherMass * p.SurfaceGravity();
    }
}
