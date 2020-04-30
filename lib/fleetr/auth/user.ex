defmodule Fleetr.Auth.User do
  @moduledoc """
  The User Schema for authentication purposes
  """
  use Fleetr.DB.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @fields ~w/email password/a
  def registration_changeset(%__MODULE__{} = user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:password, min: 8)
    |> put_password_hash()
    |> unique_constraint(:email)
  end

  defp put_password_hash(
         %Ecto.Changeset{changes: %{password: password}, valid?: true} = changeset
       ) do
    changeset
    |> put_change(:password_hash, Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset |> IO.inspect(label: :changeset)
end
