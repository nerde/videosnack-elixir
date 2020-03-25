defmodule VideosnackWeb.Router do
  use VideosnackWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug VideosnackWeb.Plugs.LoadAccount
    plug VideosnackWeb.Plugs.LoadUser
  end

  pipeline :require_account do
    plug VideosnackWeb.Plugs.RequireAccount
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/auth", VideosnackWeb do
    pipe_through :browser

    get "/new", AuthController, :new
    post "/", AuthController, :create
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", VideosnackWeb do
    pipe_through :browser

    get "/", LandingController, :index

    resources "/accounts", AccountController, only: ~w(new create)a

    scope "/:account_slug" do
      pipe_through :require_account

      get "/", AccountController, :show

      resources "/projects", ProjectController, only: ~w(new create)a
      resources "/episodes", EpisodeController, only: ~w(new create)a
      post "/uploads/presign", UploadController, :presign

      get "/:project_slug", ProjectController, :show
    end
  end
end
