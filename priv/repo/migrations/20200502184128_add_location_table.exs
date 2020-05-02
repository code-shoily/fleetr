defmodule Fleetr.Repo.Migrations.AddLocationTable do
  use Ecto.Migration

  def up do
    create_if_not_exists table(:locations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :coordinates, :geometry
    end
  end

  def down do
    drop table(:locations)
  end
end
