defmodule FleetrWeb.AuthHandler do
  alias Fleetr.Cache, as: TokenCache
  alias FleetrWeb.Router.Helpers, as: Router

  import Phoenix.LiveView

  defmacro __using__(_) do
    quote do
      alias FleetrWeb.Auth

      import FleetrWeb.AuthHandler, only: [authenticate_socket: 3]

      use FleetrWeb, :live_view

      def handle_info(:unauthorized, socket) do
        socket =
          socket
          |> put_flash(:error, "You are not authenticated. Please sign in.")
          |> push_redirect(to: Router.live_path(socket, Auth.LoginLive))

        {:noreply, socket}
      end
    end
  end

  def authenticate_socket(process, socket, session) do
    socket =
      socket
      |> assign(:user_id, nil)
      |> (fn socket ->
            case session do
              %{"token" => nil} ->
                socket

              %{"token" => token} ->
                case TokenCache.get(token) do
                  nil -> socket
                  user_id -> assign(socket, user_id: user_id)
                end

              _ ->
                socket
            end
          end).()

    unless socket.assigns.user_id, do: send(process, :unauthorized)

    socket
  end
end
