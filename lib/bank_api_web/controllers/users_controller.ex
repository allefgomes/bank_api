defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller

  def create(conn, %{"user" => user}) do
    conn
    |> put_status(201)
    |> render("user.json", %{"user" => user})
  end
end
