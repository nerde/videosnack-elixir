defmodule VideosnackWeb.ProjectController do
  use VideosnackWeb, :controller

  alias Videosnack.Project
  alias Videosnack.Repo

  plug VideosnackWeb.Plugs.RequireUser

  def new(conn, _params) do
    changeset = Project.changeset(%Project{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"project" => project, "slug" => slug}) do
    changeset = Project.changeset(%Project{}, project)

    if changeset.valid? do
      redirect(conn, to: Routes.project_path(conn, :show, slug))
    else
      render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"slug" => slug}) do
    project = Repo.get_by!(Project, slug: slug)
    render(conn, :show, project: project)
  end
end
