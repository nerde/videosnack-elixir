defmodule VideosnackWeb.AuthController do
  use VideosnackWeb, :controller
  alias Videosnack.User

  plug Ueberauth

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"user" => user}) do
    case User.authenticate(user) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.account_path(conn, :new))
      {:error, changeset} ->
        conn
        |> render(:new, changeset: changeset)
    end
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, %{"provider" => provider}) do
    case User.authenticate_oauth(provider, auth) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.account_path(conn, :new))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Sorry, we were unable to sign you in")
        |> redirect(to: Routes.auth_path(conn, :new))
    end
  end
end
