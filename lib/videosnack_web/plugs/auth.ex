defmodule VideosnackWeb.Plugs.Auth do
  import Plug.Conn

  alias Videosnack.Repo
  alias Videosnack.User

  def init(_), do: nil

  def call(conn, _) do
    user_id = get_session(conn, :user_id)

    assign(conn, :user, user_id && Repo.get(Videosnack.User, user_id))
  end
end
