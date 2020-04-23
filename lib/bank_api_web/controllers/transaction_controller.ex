defmodule BankApiWeb.TransactionController do
  use BankApiWeb, :controller
  alias BankApi.Transactions

  action_fallback BankApiWeb.FallbackController

  def all(conn, _) do
    conn
    |> render("show.json", transaction: Transactions.all())
  end

  def year(conn, %{"year" => year}) do
    conn
    |> render("show.json", transaction: Transactions.year(year))
  end

  def month(conn, %{"year" => year, "month" => month}) do
    conn
    |> render("show.json", transaction: Transactions.month(year, month))
  end

  def day(conn, %{"day" => day}) do
    conn
    |> render("show.json", transaction: Transactions.date(day))
  end
end
