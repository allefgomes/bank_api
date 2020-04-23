defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller
  alias BankApi.Accounts
  alias BankApi.Accounts.Auth.Guardian

  action_fallback BankApiWeb.FallbackController

  def index(conn, _) do
    conn
    |> render("index.json", users: Accounts.get_users())
  end

  def signup(conn, %{"user" => user}) do
    with {:ok, user, account} <- Accounts.create_user(user) do
      conn
      |> put_status(201)
      |> put_resp_header("location", Routes.user_path(conn, :show, id: user.id))
      |> render("account.json", %{user: user, account: account})
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      conn
      |> put_status(:created)
      |> render("user_auth.json", user: user, token: token)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    conn
    |> render("show.json", user: user)
  end
end
