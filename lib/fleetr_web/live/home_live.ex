defmodule FleetrWeb.HomeLive do
  @moduledoc false

  use FleetrWeb.AuthHandler

  def mount(_params, session, socket) do
    {:ok, authenticate_socket(self(), socket, session)}
  end
end
