defmodule VideosnackWeb.Router do
  use VideosnackWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug VideosnackWeb.Plugs.LoadUser
  end

  pipeline :load_account do
    plug VideosnackWeb.Plugs.LoadAccount
  end

  pipeline :require_account do
    plug VideosnackWeb.Plugs.RequireAccount
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VideosnackWeb do
    pipe_through [:browser, :load_account]

    get "/", LandingController, :index

    resources "/accounts", AccountController, only: [:new, :create]

    scope "/:account_slug" do
      pipe_through :require_account

      get "/", AccountController, :show

      resources "/projects", ProjectController, only: [:new, :create]
    end
  end

  scope "/auth", VideosnackWeb do
    pipe_through :browser

    get "/new", AuthController, :new
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
