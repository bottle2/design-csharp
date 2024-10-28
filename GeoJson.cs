using System.Text.Json;

double xMin = -28.388798290463953;
double yMin = -53.90190725591026;
double xMax = -28.388706107586515;
double yMax = -53.901802299250775;

Console.WriteLine(JsonSerializer.Serialize(new
{
    type = "FeatureCollection",
    features = new[] { new {
        type = "Feature",
        geometry = new
        {
            type = "Polygon",
            coordinates = new[] { new[]
            {
                new[] { xMin, yMin },
                      [ xMin, yMax ],
                      [ xMax, yMax ],
                      [ xMax, yMin ],
                      [ xMin, yMin ],
            }}
        },
        properties = new { id = 0 }
    }}
}));
