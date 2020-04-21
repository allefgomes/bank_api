# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BankApi.Repo.insert!(%BankApi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

user = User.changeset(%User{}, %{
  email: "allefgalmeida@gmail.com",
  name: "Allef Gomes",
  password: "12341234",
  password_confirmation: "12341234",
  role: "admin"
})
