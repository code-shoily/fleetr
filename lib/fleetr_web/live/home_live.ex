defmodule FleetrWeb.HomeLive do
  @moduledoc false

  alias Fleetr.Cache, as: TokenCache
  alias FleetrWeb.Auth

  use FleetrWeb, :live_view

  def mount(_params, %{"token" => nil}, socket) do
    send(self(), :unauthorized)
    {:ok, socket}
  end

  def mount(_params, %{"token" => token}, socket) do
    case TokenCache.get(token) do
      nil ->
        send(self(), :unauthorized)
        {:ok, socket}
      user_id -> {:ok, assign(socket, user_id: user_id)}
    end
  end

  def mount(_params, _session, socket) do
    send(self(), :unauthorized)
    {:ok, socket}
  end

  def handle_info(:unauthorized, socket) do
    socket =
      socket
      |> put_flash(:error, "You are not authenticated. Please sign in.")
      |> push_redirect(to: Routes.live_path(socket, Auth.LoginLive))

    {:noreply, socket}
  end
end
