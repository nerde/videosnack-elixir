defmodule VideosnackWeb.Plugs.LoadAccount do
  import Plug.Conn

  alias Videosnack.Repo
  alias Videosnack.Account

  def init(_), do: nil

  def call(conn, _) do
    slug = conn.path_params["account_slug"]
    assign(conn, :current_account, slug && Repo.get_by(Account, slug: slug))
  end
end
