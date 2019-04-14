defmodule VideosnackWeb.AccountController do
  use VideosnackWeb, :controller

  alias Videosnack.Account
  alias Videosnack.Member
  alias Videosnack.Repo

  plug VideosnackWeb.Plugs.RequireUser

  def new(conn, _params) do
    changeset = Account.changeset(%Account{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"account" => account}) do
    changeset = Account.changeset(%Account{}, Map.put(account, "plan_id", 1))

    if changeset.valid? do
      Repo.transaction fn -> Member.sign_up!(conn.assigns[:user], Repo.insert!(changeset)) end

      redirect(conn, to: Routes.account_path(conn, :show, account["slug"]))
    else
      render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, _params) do
    render(conn, :show)
  end
end
