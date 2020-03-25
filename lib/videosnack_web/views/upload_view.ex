defmodule VideosnackWeb.UploadView do
  use VideosnackWeb, :view

  def render("presign.json", %{presigned_url: presigned_url}) do
    %{presigned_url: presigned_url}
  end

  def render("presign.json", %{errors: errors}) do
    %{errors: errors}
  end
end
