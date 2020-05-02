defmodule Fleetr.Spatial do
  @moduledoc """
  Adds or removes locations with coordinates being in GeoJSON format.
  """
  alias __MODULE__.Location
  alias Ecto.Changeset
  alias Fleetr.Repo

  @spec add_location(map()) :: {:ok, Location.t()} | {:error, Changeset}
  def add_location(attrs) do
    Repo.insert(Location.changeset(%Location{}, attrs))
  end

  @spec locations() :: [Location.t()]
  def locations() do
    Repo.all(Location)
  end
end
