defmodule VideosnackWeb.Router do
  use VideosnackWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VideosnackWeb do
    pipe_through :browser

    get "/", LandingController, :index

    resources "/accounts", AccountController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", VideosnackWeb do
  #   pipe_through :api
  # end
end
