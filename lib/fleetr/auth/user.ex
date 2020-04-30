defmodule Fleetr.Auth.User do
  @moduledoc """
  The User Schema for authentication purposes
  """
  alias Fleetr.Helpers.Validators

  use Fleetr.DB.Schema

  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :password_confirmation, :string, virtual: true
    field :token, :string, virtual: true

    timestamps()
  end

  @fields ~w/token/a
  def token_changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

  @fields ~w/email password/a
  def login_changeset(user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
  end

  @fields ~w/email password password_confirmation/a
  def registration_changeset(%__MODULE__{} = user, params \\ %{}) do
    user
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:password, min: 8)
    |> validate_password_confirmation()
    |> put_password_hash()
    |> unique_constraint(:email)
    |> Validators.validate_email(:email)
  end

  defp put_password_hash(
         %Ecto.Changeset{changes: %{password: password}, valid?: true} = changeset
       ) do
    changeset
    |> put_change(:password_hash, Argon2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset |> IO.inspect(label: :changeset)

  defp validate_password_confirmation(%{changes: changes} = changeset) do
    if changes[:password] == changes[:password_confirmation] do
      changeset
    else
      changeset
      |> add_error(:password, "Passwords don't match")
      |> add_error(:password_confirmation, "Passwords don't match")
    end
  end
end
