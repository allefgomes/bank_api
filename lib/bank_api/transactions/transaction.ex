defmodule BankApi.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "transactions" do
    field :account_from, :string
    field :account_to, :string
    field :date, :date
    field :type, :string
    field :value, :decimal

    timestamps()
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:account_from, :account_to, :date, :type, :value])
    |> validate_required([:account_from, :account_to, :date, :type, :value])
  end
end
