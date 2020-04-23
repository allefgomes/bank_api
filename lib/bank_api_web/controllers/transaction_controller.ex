defmodule BankApiWeb.TransactionController do
  use BankApiWeb, :controller
  alias BankApi.Transactions

  action_fallback BankApiWeb.FallbackController

  def all(conn, _) do
    conn
    |> render("show.json", transaction: Transactions.all)
  end
end
