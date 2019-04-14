defmodule VideosnackWeb.Plugs.RequireAccount do
  import Plug.Conn
  use VideosnackWeb, :controller
  alias VideosnackWeb.ErrorView

  def init(_), do: nil

  def call(conn, _) do
    if conn.assigns[:current_account], do: conn,
                                       else: conn |> put_status(:not_found) |> put_view(ErrorView) |> render(:"404")
  end
end
