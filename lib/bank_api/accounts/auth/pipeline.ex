defmodule BankApi.Accounts.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :bank_api,
    module: BankApi.Accounts.Auth.Guardian,
    error_handler: BankApi.Accounts.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
