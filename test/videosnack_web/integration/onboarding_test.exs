defmodule VideosnackWeb.OnboardingTest do
  use Videosnack.DataCase
  use VideosnackWeb.RoutesCase
  use Hound.Helpers

  alias Videosnack.{Account, Member, Project, Repo, User}

  import VideosnackWeb.SessionCase

  hound_session()

  test "Signing Up", %{conn: conn} do
    authenticate(conn, "diego@gmail.com", "123456789")

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

    test "with valid user", %{conn: conn} do
      authenticate(conn, "diego@gmail.com", "123456789")

      assert Repo.aggregate(User, :count, :id) == 1
      assert visible_in_page?(~r/Create your Account/)
    end

    test "with invalid password", %{conn: conn} do
      authenticate(conn, "diego@gmail.com", "12345678")

      assert Repo.aggregate(User, :count, :id) == 1
      assert visible_in_page?(~r/Invalid password/)
    end
  end

  test "Creating my Account", %{conn: conn} do
    authenticate(conn, "diego@gmail.com", "123456789")

    find_element(:id, "account_name") |> fill_field("Code Snack")
    find_element(:id, "account_name") |> submit_element

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

  test "Creating a Project", %{conn: conn} do
    user = Repo.insert!(User.changeset(%User{}, %{email: "diego@gmail.com", encrypted_password: "123456789"}))
    acc = Repo.insert!(%Account{name: "Code Snack", slug: "code-snack", plan_id: 1})
    Member.sign_up!(user, acc)
    authenticate(conn, "diego@gmail.com", "123456789")
    navigate_to(Routes.project_path(conn, :new, acc.slug))

    find_element(:id, "project_name") |> fill_field("Rails")
    find_element(:css, "[for=distribution-subscription]") |> click
    find_element(:id, "project_price") |> fill_field("999")
    find_element(:id, "project_name") |> submit_element

    projects = Project |> Repo.all
    assert Enum.count(projects) == 1
    project = List.first(projects)
    assert project.name == "Rails"
    assert project.slug == "rails"
  end
end
