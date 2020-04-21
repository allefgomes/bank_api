defmodule BankApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "users" do
    field :email, :string
    field :name, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :role, :string

    has_one :accounts, BankApi.Accounts.Account
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :password_confirmation, :role])
    |> validate_required([:email, :name, :password, :password_confirmation, :role])
    |> validate_format(:email, ~r/@/, message: "Invalid e-mail!")
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password,
      min: 8,
      max: 100,
      message: "Password must be between 8 to 100 digits!"
    )
    |> validate_confirmation(:password, message: "Passowrd is not equal!")
    |> unique_constraint(:email, message: "User with email already exists")
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end

  defp hash_password(changeset) do
    changeset
  end
end
