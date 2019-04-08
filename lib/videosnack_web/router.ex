defmodule VideosnackWeb.Router do
  use VideosnackWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug VideosnackWeb.Plugs.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VideosnackWeb do
    pipe_through :browser

    get "/", LandingController, :index

    resources "/accounts", AccountController, only: [:new, :create]

    scope "/:slug" do
      get "/", AccountController, :show
    end
  end

  scope "/auth", VideosnackWeb do
    pipe_through :browser

    get "/new", AuthController, :new
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end
end
