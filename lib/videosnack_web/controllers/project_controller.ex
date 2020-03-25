defmodule VideosnackWeb.ProjectController do
  use VideosnackWeb, :controller

  alias Videosnack.{Account, Project, Repo}

  plug VideosnackWeb.Plugs.RequireUser

  def new(conn, _params) do
    changeset = Project.changeset(%Project{distribution: "free"})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"project" => project, "account_slug" => account_slug}) do
    changeset = Project.changeset(%Project{account_id: conn.assigns[:current_account].id}, project)

    case Repo.insert(changeset) do
      {:ok, project} -> redirect(conn, to: Routes.project_path(conn, :show, account_slug, project.slug))
      {:error, changeset} -> render(conn, :new, changeset: changeset)
    end
  end

  def show(%{assigns: %{current_account: account}} = conn, %{"project_slug" => slug}) do
    project = Repo.get_by!(Project, slug: slug, account_id: account.id)
    render(conn, :show, project: project)
  end
end
