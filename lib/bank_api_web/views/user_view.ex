defmodule BankApiWeb.UserView do
  use BankApiWeb, :view

  def render("account.json", %{user: user, account: account}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
      account: %{
        balance: account.balance,
        account_id: account.id
      }
    }
  end

  def render("index.json", %{users: users}) do
    %{
      data: render_many(users, __MODULE__, "user.json")
    }
  end

  def render("show.json", %{user: user}) do
    render_one(user, __MODULE__, "user.json")
  end

  def render("user_auth.json", %{user: user, token: token}) do
    user = Map.put(render_one(user, __MODULE__, "user.json"), :token, token)

    %{ data: user }
  end

  def render("user.json", %{user: user}) do
    render("account.json", %{user: user, account: user.accounts})
  end
end
