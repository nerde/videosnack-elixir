defmodule Videosnack.Repo do
  use Ecto.Repo,
    otp_app: :videosnack,
    adapter: Ecto.Adapters.Postgres
end
