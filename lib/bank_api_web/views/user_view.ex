defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("account.json", %{user: user, account: account}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      account: %{
        balance: account.balance,
        account_id: account.id,
      }
    }
  end
end
