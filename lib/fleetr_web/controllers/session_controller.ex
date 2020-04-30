defmodule FleetrWeb.SessionController do
  alias Fleetr.Cache, as: TokenCache
  alias FleetrWeb.HomeLive
  alias FleetrWeb.Auth.LoginLive
  alias FleetrWeb.Router.Helpers, as: Routes
  alias FleetrWeb.Endpoint

  alias Phoenix.Token

  use FleetrWeb, :controller

  @typep maybe_token :: binary() | nil

  def create(conn, %{"user" => %{"token" => token}}) do
    home = Routes.live_path(Endpoint, HomeLive)

    redirect(put_session(conn, "token", new_token(token)), to: home)
  end

  def destroy(conn, _params) do
    signin = Routes.live_path(Endpoint, LoginLive)
    redirect(clear_session(conn), to: signin)
  end

  @spec new_token(maybe_token) :: maybe_token
  defp new_token(token) do
    case Token.verify(Endpoint, "auth uid", token, max_age: 10) do
      {:ok, value} ->
        Endpoint
        |> Token.sign("auth uid", value)
        |> TokenCache.set(value, return: :key)
      _ -> nil
    end
  end
end
