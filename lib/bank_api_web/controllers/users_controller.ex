defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller
  alias BankApi.Accounts

  action_fallback BankApiWeb.FallbackController

  def create(conn, %{"user" => user}) do
    with {:ok, user, account} <- Accounts.create_user(user) do
      conn
      |> put_status(201)
      |> render("account.json", %{user: user, account: account})
    end
  end
end
