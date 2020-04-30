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
  @spec authenticate(map()) :: {:ok, user()} | {:error, any()}
  def authenticate(params \\ %{}) do
    changeset = User.login_changeset(%User{}, params)

    with %{valid?: true, changes: changes} <- changeset,
         {:ok, user} <- check_password(changes.email, changes.password) do
      {:ok, user}
    else
      %Ecto.Changeset{} = changeset ->
        {:error, changeset}

      {:error, _} ->
        {:error, Ecto.Changeset.add_error(changeset, :base, "Invalid Login")}
    end
  end

  defp check_password(email, password) do
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
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> PaperTrail.insert()
  end
end
