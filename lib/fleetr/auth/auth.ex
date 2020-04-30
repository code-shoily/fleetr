defmodule Fleetr.Auth do
  alias Fleetr.Auth.User
  alias Fleetr.Repo

  import Ecto.Query

  @type id :: String.t()
  @type email :: String.t()
  @type password :: String.t()
  @type user :: User.t()

  @doc """
  Returns password verified user
  """
  @spec authenticated_user(email, password) :: {:ok, user()}
  def authenticated_user(email, password) do
    User
    |> where([u], u.email == ^email)
    |> Repo.one()
    |> Argon2.check_pass(password)
  end

  @doc """
  Returns the user for this id.
  """
  @spec user_by_id(id()) :: user()
  def user_by_id(id) do
    Repo.get_by(User, id: id)
  end

  @doc """
  Creates a user
  """
  @spec create_user(map()) :: {:ok, user()} | {:error, Ecto.Changeset.t()}
  def create_user(%{email: _email, password: _password} = params) do
    %User{}
    |> User.changeset(params)
    |> Repo.insert()
  end
end
