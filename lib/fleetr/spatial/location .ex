defmodule Fleetr.Spatial.Location do
  alias Geo.PostGIS.Geometry

  use Fleetr.DB.Schema

  import Ecto.Changeset

  schema "locations" do
    field :name, :string
    field :coordinates, Geometry
  end

  @fields ~w/name coordinates/a
  def changeset(location, params \\ %{}) do
    location
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
