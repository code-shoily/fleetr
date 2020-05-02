defmodule FleetrWeb.LocationController do
  alias Fleetr.Spatial

  use FleetrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json", locations: Spatial.locations())
  end

  @doc """
  Creates a new location.
  Use `curl \
    -X POST http://localhost:4000/api/locations \
    -H "Expect:" \
    -H 'Content-Type: application/json; charset=utf-8' \
    --data-binary @- << EOF
    {
      "coordinates": {
        "coordinates": [43.6426, 79.3871],
        "crs": {
          "properties": {
            "name": "EPSG:4326"
          },
          "type": "name"
        },
        "type": "Point"
      },
      "name": "CN Tower"
    }
  """
  def create(conn, params) do
    params
    |> decode_location()
    |> Spatial.add_location()
    text conn, "DONE"
  end

  defp decode_location(location) do
    coordinates = location["coordinates"] && Geo.JSON.decode!(location["coordinates"]) || nil
    location
    |> Map.put("coordinates", coordinates)
  end
end
