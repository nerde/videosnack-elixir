defmodule VideosnackWeb.SessionCase do
  use Hound.Helpers

  def authenticate(email, password) do
    navigate_to("/auth/new")

    find_element(:id, "user_email") |> fill_field(email)

    passwordField = find_element(:id, "user_encrypted_password")
    fill_field(passwordField, password)

    submit_element(passwordField)
  end
end
