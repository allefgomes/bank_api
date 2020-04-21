defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller
  alias BankApi.Accounts

  def create(conn, %{"user" => user}) do
    {:ok, account} = Accounts.create_user(user)
    conn
    |> put_status(201)
    |> render("account.json", %{account: account})
  end
end
