defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("account.json", %{account: account}) do
    %{
      balance: account.balance,
      account_id: account.id,
      user: %{
        email: account.user.email,
        name: account.user.name,
        role: account.user.role,
        id: account.user.id
      }
    }
  end
end
