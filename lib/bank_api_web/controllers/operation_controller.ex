defmodule BankApiWeb.OperationController do
  use BankApiWeb, :controller
  alias BankApi.Operations

  action_fallback BankApiWeb.FallbackController

  def transfer(conn, %{"from_account_id" => from_id, "to_account_id" => to_id, "value" => value}) do
    with {:ok, message} <- Operations.transfer(from_id, to_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
