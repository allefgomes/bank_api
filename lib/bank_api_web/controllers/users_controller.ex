defmodule BankApiWeb.UserController do
  use BankApiWeb, :controller
  alias BankApi.Accounts

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
    user = BankApi.Repo.get!(BankApi.Accounts.User, "efaa7058-65e6-4262-b08f-2a188040abd4")
    |> BankApi.Repo.preload(:accounts)

    render(conn, "user_auth.json", user: user, token: "token")
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    conn
    |> render("show.json", user: user)
  end
end
