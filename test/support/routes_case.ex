defmodule VideosnackWeb.RoutesCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias VideosnackWeb.Router.Helpers, as: Routes
    end
  end

  setup do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
