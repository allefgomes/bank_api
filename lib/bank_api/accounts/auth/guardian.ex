defmodule BankApi.Accounts.Auth.Guardian do
  use Guardian, otp_app: :bank_api
  alias BankApi.Accounts.Auth.Session
  alias BankApi.Accounts

  def authenticate(email, password) do
    case Session.authenticate(email, password) do
      {:ok, user} -> create_token(user)
      _ -> {:error, :unauthorized}
    end
  end

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    {:ok, Accounts.get_user!(id)}
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end
