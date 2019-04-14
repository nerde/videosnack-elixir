defmodule VideosnackWeb.ProjectView do
  use VideosnackWeb, :view

  def distribution_tootlips do
    %{
      "free" => "Free and open access to the project. You can still have individually paid episodes in it",
      "subscription" => "Charge subscribers a montly fee to access this project. You can still have both free and individually paid episodes in it",
      "purchase" => "Charge subscribers a single fee to access this project. You can still have both free and individually paid episodes in it",
    }
  end
end
