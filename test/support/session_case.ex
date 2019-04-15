defmodule VideosnackWeb.SessionCase do
  use Hound.Helpers
  alias VideosnackWeb.Router.Helpers, as: Routes

  def authenticate(conn, email, password) do
    navigate_to(Routes.auth_path(conn, :new))

    find_element(:id, "user_email") |> fill_field(email)

    passwordField = find_element(:id, "user_encrypted_password")
    fill_field(passwordField, password)

    submit_element(passwordField)
  end
end
