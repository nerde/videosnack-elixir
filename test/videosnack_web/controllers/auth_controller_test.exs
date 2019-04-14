defmodule VideosnackWeb.AuthControllerTest do
  use VideosnackWeb.ConnCase

  alias Videosnack.{Repo, User}

  test "callback/2 authenticates from Github", %{conn: conn} do
    auth = %{
      credentials: %{token: "aaaaaa"},
      info: %{email: "diego@gmail.com", name: "Diego Selzlein", image: "http://github.com/images/diego"},
      provider: :github
    }

    conn
    |> assign(:ueberauth_auth, auth)
    |> get("/auth/github/callback")

    users = User |> Repo.all
    assert Enum.count(users) == 1
    user = List.first(users)
    assert user.email == "diego@gmail.com"
    assert user.name == "Diego Selzlein"
    assert user.provider == "github"
    assert user.token == "aaaaaa"
    assert user.avatar_url == "http://github.com/images/diego"
  end
end
