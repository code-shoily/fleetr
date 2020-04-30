defmodule Fleetr.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create_if_not_exists unique_index(:users, [:email])
  end
end
