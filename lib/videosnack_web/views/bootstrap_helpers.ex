defmodule VideosnackWeb.BootstrapHelpers do
  use Phoenix.HTML
  import Phoenix.Controller, only: [get_flash: 2]

  def bs_form_for(changeset, path, func) do
    form_for(changeset, path, [class: form_classes(changeset)], func)
  end

  def form_classes(changeset) do
    [{"was-validated", was_validated?(changeset)}]
    |> Enum.filter(& elem(&1, 1))
    |> Enum.map(& elem(&1, 0))
    |> Enum.join(" ")
  end

  def was_validated?(changeset) do
    changeset.action && !Enum.empty?(changeset.errors)
  end

  def flash_alerts(conn) do
    [info: :info, error: :danger]
    |> Enum.map(fn {key, class} -> {get_flash(conn, key), class} end)
    |> Enum.reject(& is_nil(elem(&1, 0)))
    |> Enum.map(fn {msg, class} -> alert_tag(class, msg) end)
  end

  def alert_tag(type, message) do
    content_tag(:p, message, class: "alert alert-#{type}", role: "alert")
  end
end
