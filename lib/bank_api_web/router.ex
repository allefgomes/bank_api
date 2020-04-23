defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/auth", BankApiWeb do
    post "/sign_up", UserController, :signup
    post "/sign_in", UserController, :signin
  end

  scope "/api", BankApiWeb do
    pipe_through :api

    get "/user", UserController, :show
    get "/users", UserController, :index

    post "/operations/transfer", OperationController, :transfer
    post "/operations/withdraw", OperationController, :withdraw

    get "/transactions/all", TransactionController, :all
    get "/transactions/year/:year", TransactionController, :year
    get "/transactions/year/:year/month/:month", TransactionController, :month
    get "/transactions/day/:day", TransactionController, :day
  end
end
