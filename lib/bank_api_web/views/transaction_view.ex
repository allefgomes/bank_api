defmodule BankApiWeb.TransactionView do
  use BankApiWeb, :view

  def render("show.json", %{transaction: transaction}) do
    %{ data: render_one(transaction, __MODULE__, "transaction.json") }
  end

  def render("transaction.json", %{transaction: transaction}) do
    transactions_list =
      Enum.map(transaction.transactions, fn item ->
        %{
          date: item.date,
          account_from: item.account_from,
          account_to: item.account_to,
          type: item.type,
          value: item.value
        }
      end)

    %{transactions_list: transactions_list, total: transaction.total}
  end
end
