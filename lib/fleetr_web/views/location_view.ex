defmodule FleetrWeb.LocationView do
  use FleetrWeb, :view

  def render("index.json", %{locations: locations}) do
    render_many(locations, __MODULE__, "location.json", as: :location)
  end

  def render("location.json", %{location: location}) do
    %{
      name: location.name,
      coordinates: Geo.JSON.encode!(location.coordinates)
    }
  end
end
