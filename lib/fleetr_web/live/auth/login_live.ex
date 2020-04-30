defmodule FleetrWeb.Auth.LoginLive do
  @moduledoc false

  use Phoenix.LiveView,
    layout: {FleetrWeb.LayoutView, "auth.html"}

  alias Fleetr.Auth
  alias Fleetr.Auth.User
  alias Fleetr.Cache, as: TokenCache
  alias FleetrWeb.AuthView

  @impl true
  def render(assigns) do
    Phoenix.View.render(AuthView, "login.html", assigns)
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(token_changeset: User.token_changeset(%User{}))
      |> assign(has_credential_error: false)
      |> assign(
        changeset: User.registration_changeset(%User{})
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    case Auth.authenticate(params) do
      {:ok, %{id: id}} ->
        token =
          FleetrWeb.Endpoint
          |> Phoenix.Token.sign("auth uid", id)
          |> TokenCache.set(id, return: :key, ttl: 10)

        socket =
          socket
          |> assign(has_credential_error: false)
          |> assign(token_changeset: User.token_changeset(%User{token: token}))

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(changeset: %{changeset | action: :insert})
          |> assign(has_credential_error: (changeset.errors[:base] && true) || false)

        {:noreply, socket}
    end
  end
end
