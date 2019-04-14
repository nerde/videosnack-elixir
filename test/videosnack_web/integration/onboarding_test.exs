defmodule OnboardingTest do
  use Videosnack.DataCase
  use Hound.Helpers

  alias Videosnack.{Account, Member, Repo, User}

  import VideosnackWeb.SessionCase

  hound_session()

  test "Signing Up", _meta do
    authenticate("diego@gmail.com", "123456789")

    users = User |> Repo.all
    assert Enum.count(users) == 1
    user = List.first(users)
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

  test "Creating my Account", _meta do
    authenticate("diego@gmail.com", "123456789")

    find_element(:id, "account_name") |> fill_field("Code Snack")
    find_element(:id, "account_name") |> submit_element()

    accounts = Account |> Repo.all
    assert Enum.count(accounts) == 1
    account = List.first(accounts)
    assert account.name == "Code Snack"
    assert account.slug == "code-snack"
    assert account.plan_id == 1
    members = Member |> Repo.all
    assert Enum.count(members) == 1
    member = List.first(members)
    assert member.account_id == account.id
    assert member.user_id == Repo.get_by!(User, email: "diego@gmail.com").id
    assert member.role == "owner"
  end
end
