defmodule BankApi.Operations do
  alias BankApi.Accounts
  alias BankApi.Accounts.Account
  alias BankApi.Repo
  alias BankApi.Transactions.Transaction
  alias Ecto.Multi

  @withdraw "withdraw"
  @transfer "transfer"
  def transfer(from, to_id, value) do
    case is_negative?(from.accounts.balance, value) do
      true -> {:error, "you can`t have negative balance!"}
      false -> perform_update(from, to_id, value)
    end
  end

  def withdraw(from, value) do
    case is_negative?(from.accounts.balance, value) do
      true ->
        {:error, "you can`t have negative balance!"}

      false ->
        withdraw_operations(from, value)
    end
  end

  defp withdraw_operations(from, value) do
    message = "Withdraw with success!! from: #{from.name}, value: #{value}"

    Multi.new()
    |> Multi.update(:account_from, perform_operation(from.accounts, value, :sub))
    |> Multi.insert(:transaction, generate_transaction(from.id, nil, @withdraw, value))
    |> Repo.transaction()
    |> transaction_case(message)
  end

  def perform_update(from, to_id, value) do
    to = Accounts.get!(to_id)

    message = "Tranfer with success!! from: #{from.name} to: #{to.user.name} value: #{value}"

    Multi.new()
    |> Multi.update(:account_from, perform_operation(from.accounts, value, :sub))
    |> Multi.update(:account_to, perform_operation(to, value, :add))
    |> Multi.insert(:transaction, generate_transaction(from.id, to.id, @transfer, value))
    |> Repo.transaction()
    |> transaction_case(message)
  end

  def perform_operation(account, value, :sub) do
    account
    |> update_account(%{balance: Decimal.sub(account.balance, value)})
  end

  def perform_operation(account, value, :add) do
    account
    |> update_account(%{balance: Decimal.add(account.balance, value)})
  end

  defp update_account(%Account{} = account, attrs) do
    Account.changeset(account, attrs)
  end

  defp transaction_case(operations, message) do
    case operations do
      {:ok, _} ->
        {:ok, message}

      {:error, :account_from, changeset, _} ->
        {:error, changeset}

      {:error, :account_to, changeset, _} ->
        {:error, changeset}
    end
  end

  defp generate_transaction(from_id, to_id, type, value) do
    %Transaction{
      account_from: from_id,
      account_to: to_id,
      type: type,
      value: value,
      date: Date.utc_today()
    }
  end

  defp is_negative?(balance, value) do
    Decimal.sub(balance, value)
    |> Decimal.negative?()
  end
end
