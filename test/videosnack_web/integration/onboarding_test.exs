defmodule OnboardingTest do
  use Videosnack.DataCase
  use Hound.Helpers

  alias Videosnack.{Repo, User}

  import VideosnackWeb.SessionCase

  hound_session()

  test "Signing Up", _meta do
    authenticate("diego@gmail.com", "123456789")

    assert Repo.aggregate(User, :count, :id) == 1
    user = Repo.one(User)
    assert user.email == "diego@gmail.com"
    assert {:ok, _} = Comeonin.Bcrypt.check_pass(user, "123456789")
    assert visible_in_page?(~r/Create your Account/)
  end

  describe "Signing In" do
    setup do
      Repo.insert!(User.changeset(%User{}, %{email: "diego@gmail.com", encrypted_password: "123456789"}))

      :ok
    end

    test "with valid user", _meta do
      authenticate("diego@gmail.com", "123456789")

      assert Repo.aggregate(User, :count, :id) == 1
      assert visible_in_page?(~r/Create your Account/)
    end

    test "with invalid password", _meta do
      authenticate("diego@gmail.com", "12345678")

      assert Repo.aggregate(User, :count, :id) == 1
      assert visible_in_page?(~r/Invalid password/)
    end
  end
end
