defmodule BankApi.Transactions do
  alias BankApi.Repo
  alias BankApi.Transactions.Transaction

  import Ecto.Query, warn: false

  def all do
    Repo.all(Transaction)
    |> create_payload()
  end

  def create_payload(transactions) do
    %{transactions: transactions, total: calculate_value(transactions)}
  end

  def calculate_value(transactions) do
    Enum.reduce(transactions, Decimal.new("0"), fn t, acc ->
      Decimal.add(acc, t.value)
    end)
  end

  def create_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end
end
