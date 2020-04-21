defmodule BankApi.Accounts do
  alias BankApi.Repo
  alias BankApi.Accounts.{User, Account}
  alias Ecto.Multi

  def create_user(attrs \\ %{}) do
    case start_transaction(attrs) do
      {:ok, operations} -> {:ok, operations.user, operations.account}
      {:error, :user, changeset, _} -> {:error, changeset}
    end
  end

  def start_transaction(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:user, insert_user(attrs))
    |> Multi.insert(:account, fn %{user: user} ->
      user
      |> Ecto.build_assoc(:accounts)
      |> Account.changeset()
    end)
    |> Repo.transaction()
  end

  defp insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
  end
end
