defmodule BankApi.Accounts.Auth.Session do
  import Ecto.Query, warn: false

  alias BankApi.Repo
  alias BankApi.Accounts.User

  def authenticate(email, password) do
    query = from u in User, where: u.email == ^email

    case Repo.one(query) do
      nil ->
        Comeonin.Argon2.dummy_checkpw()
        {:error, :not_found}

      user ->
        if Comeonin.Argon2.checkpw(password, user.password_hash) do
          {:ok, user |> Repo.preload(:accounts)}
        else
          {:error, :unauthorized}
        end
    end
  end
end
