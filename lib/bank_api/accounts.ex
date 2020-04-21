defmodule BankApi.Accounts do
  alias BankApi.Repo
  alias BankApi.Accounts.{User, Account}

  def create_user(attrs \\ %{}) do
    case insert_user(attrs) do
      {:ok, user} ->
        {:ok, account} = user
        |> Ecto.build_assoc(:accounts)
        |> Account.changeset()
        |> Repo.insert
        {:ok, account |> Repo.preload(:user) }

      {:error, changeset} -> {:error, changeset}
    end
  end

  defp insert_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
