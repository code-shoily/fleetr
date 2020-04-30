defmodule FleetrWeb.HomeLive do
  @moduledoc false

  use FleetrWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
