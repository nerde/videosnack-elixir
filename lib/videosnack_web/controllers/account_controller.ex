defmodule VideosnackWeb.AccountController do
  use VideosnackWeb, :controller
  alias Videosnack.Account

  def new(conn, _params) do
    changeset = Account.changeset(%Account{})
    render(conn, "new.html", changeset: changeset)
  end
end
