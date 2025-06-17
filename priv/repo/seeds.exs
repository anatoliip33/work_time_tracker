# Script for adding initial user to the database:
#     mix run priv/repo/seeds.exs
alias WorkTimeTracker.Cards

Cards.create_user(%{first_name: "Anatolii", last_name: "Polishchuk"})
