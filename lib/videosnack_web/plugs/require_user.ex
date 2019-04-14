defmodule VideosnackWeb.Plugs.RequireUser do
  import Plug.Conn
  use VideosnackWeb, :controller

  def init(_), do: nil

  def call(conn, _) do
    if conn.assigns.user, do: conn, else: conn |> redirect(to: Routes.auth_path(conn, :new)) |> halt()
  end
end
