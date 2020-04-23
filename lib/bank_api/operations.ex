defmodule BankApi.Operations do
  alias BankApi.Accounts
  alias BankApi.Accounts.Account
  alias BankApi.Repo

  def transfer(from_id, to_id, value) do
    from = Accounts.get!(from_id)
    value = Decimal.new(value)

    case is_negative?(from.balance, value) do
      true -> {:error, "you can`t have negative balance!"}
      false -> perform_update(from, to_id, value)
    end
  end

  def withdraw(from_id, value) do
    from = Accounts.get!(from_id)
    value = Decimal.new(value)

    case is_negative?(from.balance, value) do
      true -> {:error, "you can`t have negative balance!"}
      false ->
        {:ok, from} = perform_operation(from, value, :sub) |> Repo.update()
        {:ok, "Withdraw with success!! from: #{user_name(from)}, value: #{value}"}
    end
  end

  defp is_negative?(from_balance, value) do
    Decimal.sub(from_balance, value)
    |> Decimal.negative?()
  end

  def perform_update(from, to_id, value) do
    to = Accounts.get!(to_id)

    transaction = Ecto.Multi.new()
    |> Ecto.Multi.update(:account_from, perform_operation(from, value, :sub))
    |> Ecto.Multi.update(:account_to, perform_operation(to, value, :add))
    |> Repo.transaction()

    case transaction do
      {:ok, _} ->
        {:ok, "Tranfer with success!! from: #{user_name(from)} to: #{user_name(to)} value: #{value}"}
      {:error, :account_from, changeset, _} -> {:error, changeset}
      {:error, :account_to, changeset, _} -> {:error, changeset}
    end
  end

  defp user_name(account) do
    account.user.name
  end

  def perform_operation(account, value, :sub) do
    account
    |> update_account(%{balance: Decimal.sub(account.balance, value)})
  end

  def perform_operation(account, value, :add) do
    account
    |> update_account(%{balance: Decimal.add(account.balance, value)})
  end

  def update_account(%Account{} = account, attrs) do
    Account.changeset(account, attrs)
  end
end
