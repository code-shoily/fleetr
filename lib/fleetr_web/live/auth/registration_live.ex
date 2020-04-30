defmodule FleetrWeb.Auth.RegistrationLive do
  @moduledoc false

  use Phoenix.LiveView,
    layout: {FleetrWeb.LayoutView, "auth.html"}

  alias Fleetr.Auth
  alias Fleetr.Auth.User
  alias FleetrWeb.AuthView
  alias FleetrWeb.Router.Helpers, as: Routes

  @impl true
  def render(assigns) do
    Phoenix.View.render(AuthView, "registration.html", assigns)
  end

  @impl true
  def mount(_params, _sessions, socket) do
    changeset = User.registration_changeset(%User{})

    socket =
      socket
      |> assign(:changeset, changeset)

    {:ok, socket}
  end

  @impl true
  def handle_event("save", %{"user" => params}, socket) do
    case Auth.create_user(params) do
      {:ok, _} ->
        socket =
          socket
          |> put_flash(:info, "Successfully signed up")
          |> push_redirect(to: Routes.live_path(socket, FleetrWeb.Auth.LoginLive))

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(changeset: changeset)

        {:noreply, socket}
    end
  end
end
