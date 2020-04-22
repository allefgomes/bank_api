defmodule BankApiWeb.OperationView do
  use BankApiWeb, :view

  def render("success.json", %{message: message}) do
    %{message: message}
  end
end
