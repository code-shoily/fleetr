defmodule FleetrWeb.Common.NavbarComponent do
  alias Fleetr.Auth

  use FleetrWeb, :live_component

  def update(%{user_id: user_id}, socket) do
    user = (user_id && Auth.user_by_id(user_id)) || nil
    {:ok, assign(socket, user: user)}
  end

  def handle_event("user-update", _, socket) do
    IO.inspect("Profile will be updated for #{user_id(socket)}")
    {:noreply, socket}
  end

  def handle_event("user-update-password", _, socket) do
    IO.inspect("Password will be changed for #{user_id(socket)}")
    {:noreply, socket}
  end

  defp user_id(socket), do: socket.assigns.user["user_id"]

  defp pretty_print(%{email: email}), do: email
  defp pretty_print(_), do: ""

  def render(assigns) do
    ~L"""
    <nav class="navbar is-primary">
      <div class="navbar-brand">
        <div class="navbar-item">
          <span class="title is-3 has-text-white">
          <span class="has-text-weight-light">Fleetr</span>
          </span>
        </div>
        <div class="navbar-burger burger" data-target="nav-menu">
          <span></span>
          <span></span>
          <span></span>
        </div>
      </div>
      <div id="nav-menu" class="navbar-menu">
      <div class="navbar-end">
        <div class="navbar-item has-dropdown is-hoverable">
          <a class="navbar-item has-text-white navbar-link">
            <%= pretty_print(@user) %>
          </a>
          <div class="navbar-dropdown is-right">
            <a class="navbar-item" href="#" phx-click="user-update" phx-target="<%= @myself %>">
              Update Profile
            </a>
            <a class="navbar-item" href="#" phx-click="user-update-password" phx-target="<%= @myself %>">
              Change Password
            </a>
            <hr class="navbar-divider">
            <a class="navbar-item has-text-danger" href="/logout">
              Logout
            </a>
          </div>
        </div>
      </div>
    </div>
    </nav>
    """
  end
end
