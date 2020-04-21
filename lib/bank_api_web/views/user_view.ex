defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("user.json", %{"user" => user}) do
    user
  end
end
