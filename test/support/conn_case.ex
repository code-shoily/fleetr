defmodule FleetrWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use FleetrWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """
  alias Ecto.Adapters.SQL.Sandbox
  alias Phoenix.ConnTest

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import FleetrWeb.ConnCase

      alias FleetrWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint FleetrWeb.Endpoint
    end
  end

  setup tags do
    :ok = Sandbox.checkout(Fleetr.Repo)

    unless tags[:async] do
      Sandbox.mode(Fleetr.Repo, {:shared, self()})
    end

    {:ok, conn: ConnTest.build_conn()}
  end
end
