defmodule BankApi.Transactions do
  alias BankApi.Repo
  alias BankApi.Transactions.Transaction

  import Ecto.Query, warn: false

  def all do
    Repo.all(Transaction)
    |> create_payload()
  end

  def year(year) do
    filter_query(
      convert_to_date({String.to_integer(year), 01, 01}),
      convert_to_date({String.to_integer(year), 12, 31})
    )
  end

  def month(year, month) do
    start_date = convert_to_date({String.to_integer(year), String.to_integer(month), 01})

    days_in_month = start_date |> Date.days_in_month()
    end_date = convert_to_date({String.to_integer(year), String.to_integer(month), days_in_month})

    filter_query(start_date, end_date)
  end

  def date(date) do
    query = from t in Transaction, where: t.date == ^Date.from_iso8601!(date)

    Repo.all(query)
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

  defp convert_to_date(date) do
    Date.from_erl!(date)
  end

  defp filter_query(start_date, end_date) do
    query = from t in Transaction, where: t.date >= ^start_date and t.date <= ^end_date

    Repo.all(query)
    |> create_payload()
  end
end
