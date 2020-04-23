defmodule BankApiWeb.OperationController do
  use BankApiWeb, :controller
  alias BankApi.Operations

  action_fallback BankApiWeb.FallbackController

  def transfer(conn, %{"to_account_id" => to_id, "value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    value = Decimal.new(value)

    with {:ok, message} <- Operations.transfer(user, to_id, value) do
      conn
      |> render("success.json", message: message)
    end
  end

  def withdraw(conn, %{"value" => value}) do
    user = Guardian.Plug.current_resource(conn)
    value = Decimal.new(value)

    with {:ok, message} <- Operations.withdraw(user, value) do
      conn
      |> render("success.json", message: message)
    end
  end
end
