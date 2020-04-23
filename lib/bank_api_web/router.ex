defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankApiWeb do
    pipe_through :api

    post "/users/sign_up", UserController, :create
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
