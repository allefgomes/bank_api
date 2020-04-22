defmodule BankApi.Operations do
  alias BankApi.{Accounts, Accounts.Account}
  alias BankApi.Repo

  def transfer(from_id, to_id, value) do
    case equal_accounts?(from_id, to_id) do
      true -> {:error, "You can't tranfer money to yourself"}
      false -> init_transfer(from_id, to_id, value)
    end
  end

  defp init_transfer(from_id, to_id, value) do
    from = Accounts.get!(from_id)

    case is_negative?(from.balance, value) do
      true -> {:error, "You can't have negative balance!"}
      false -> perform_update(from, to_id, value)
    end
  end

  defp equal_accounts?(from_id, to_id) do
    from_id === to_id
  end

  defp is_negative?(from_balance, value) do
    value = Decimal.new(value)
    Decimal.new(from_balance)

    |> Decimal.sub(value)
    |> Decimal.negative?()
  end

  defp perform_update(from, to_id, value) do
    from
    |> perform_operation(value, :sub)

    to = Accounts.get!(to_id)
    |> perform_operation(value, :sum)

    {:ok, "Transfered with success! From: #{from.user.name} to: #{to.user.name} value: R$ #{value}"}
  end

  def perform_operation(account, value, :sub) do
    account
    |> update_account(%{balance: Decimal.sub(account.balance, value)})
  end

  def perform_operation(account, value, :sum) do
    account
    |> update_account(%{balance: Decimal.add(account.balance, value)})
  end

  def update_account(%Account{} = account, attrs) do
    IO.inspect(account)
    Account.changeset(account, attrs)
    |> Repo.update!
  end
end
