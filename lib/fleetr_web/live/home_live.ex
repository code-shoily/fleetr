defmodule FleetrWeb.HomeLive do
  @moduledoc false

  alias Fleetr.Cache, as: TokenCache
  alias FleetrWeb.Auth

  use FleetrWeb, :live_view

  def mount(_params, session, socket) do
    socket = assign(socket, :user_id, nil)

    case session do
      %{"token" => nil} ->
        send(self(), :unauthorized)
        {:ok, socket}
      %{"token" => token} ->
        case TokenCache.get(token) do
          nil ->
            send(self(), :unauthorized)
            {:ok, socket}
          user_id -> {:ok, assign(socket, user_id: user_id)}
        end
      _ ->
        send(self(), :unauthorized)
        {:ok, socket}
    end
  end

  def handle_info(:unauthorized, socket) do
    socket =
      socket
      |> put_flash(:error, "You are not authenticated. Please sign in.")
      |> push_redirect(to: Routes.live_path(socket, Auth.LoginLive))

    {:noreply, socket}
  end
end
