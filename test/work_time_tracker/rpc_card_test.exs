defmodule WorkTimeTracker.RpcCardTest do
  use ExUnit.Case, async: false

  alias WorkTimeTracker.Rpc.Client
  alias WorkTimeTracker.Cards

  @valid_user_attrs %{first_name: "Anatolii", last_name: "Polishchuk"}
  @valid_card_uid Ecto.UUID.generate()

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(WorkTimeTracker.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(WorkTimeTracker.Repo, {:shared, self()})

    {:ok, user} = Cards.create_user(@valid_user_attrs)
    {:ok, card} = Cards.add(%{card_uid: @valid_card_uid, user_id: user.id})

    %{user: user, card: card}
  end

  describe "RPC card operations" do
    test "/card/touch with valid card returns user data", %{user: user, card: card} do
      response = Client.call("/card/touch", %{"card_uid" => card.card_uid})
      assert response == %{"card_uid" => card.card_uid, "user_id" => user.id}
    end

    test "/card/touch with invalid UUID format returns error" do
      response = Client.call("/card/touch", %{"card_uid" => "invalid-uuid"})
      assert response == %{"card_uid" => ["is invalid"]}
    end

    test "/card/touch with non-existent card_uid returns nil" do
      assert nil == Client.call("/card/touch", %{"card_uid" => Ecto.UUID.generate()})
    end

    test "/card/assign with valid data creates new card", %{user: user} do
      new_card_uid = Ecto.UUID.generate()

      response = Client.call("/card/assign", %{"card_uid" => new_card_uid, "user_id" => user.id})

      created_card = Cards.get(new_card_uid)

      assert created_card != nil
      assert response == %{"card_uid" => new_card_uid, "user_id" => user.id}
    end

    test "/card/assign check uniqueness during insert new card", %{user: user, card: card} do
      response = Client.call("/card/assign", %{
        "card_uid" => card.card_uid,
        "user_id" => user.id
      })

      assert response == %{"error" => %{"card_uid" => ["has already been taken"]}}
    end

    test "/card/assign with invalid data returns error", %{user: user} do
      response = Client.call("/card/assign", %{
        "card_uid" => "invalid-uuid",
        "user_id" => nil
      })

      assert response == %{"error" => %{"card_uid" => ["is invalid"], "user_id" => ["can't be blank"]}}
    end

    test "/card/assign with non-existent user returns error" do
      non_existent_user_id = 1001

      response = Client.call("/card/assign", %{
        "card_uid" => Ecto.UUID.generate(),
        "user_id" => non_existent_user_id
      })

      assert response == %{"error" => %{"user_id" => ["does not exist"]}}
    end

    test "/card/delete removes existing card", %{card: card} do
      response = Client.call("/card/delete", %{"card_uid" => card.card_uid})
      assert response == %{
        "card_uid" => card.card_uid,
        "user_id" => card.user_id
      }

      assert Cards.get(card.card_uid) == nil
    end

    test "/card/delete with not existing card_uid" do
      response = Client.call("/card/delete", %{"card_uid" => Ecto.UUID.generate()})
      assert response == nil
    end

    test "/card/list_by_user find card of existing user", %{user: user, card: card} do
      response = Client.call("/card/list_by_user", %{"user_id" => user.id})

      assert response == %{"user_id" => [card.card_uid]}
    end

    test "/card/list_by_user find card of non-existing user" do
      non_existent_user_id = 1001
      response = Client.call("/card/list_by_user", %{"user_id" => non_existent_user_id})

      assert response == %{"user_id" => []}
    end

    test "/card/delete_all_by_user existing user", %{user: user, card: card} do
      response = Client.call("/card/delete_all_by_user", %{"user_id" => user.id})

      assert response == %{"user_id" => [card.card_uid]}
    end

    test "/card/delete_all_by_user non existing user", %{user: user} do
      non_existent_user_id = 1001

      response = Client.call("/card/delete_all_by_user", %{"user_id" => non_existent_user_id})

      assert response == %{"user_id" => []}
    end

    test "/card/delete_all_by_user existing no user_id parameter" do
      response = Client.call("/card/delete_all_by_user", %{})

      assert response == %{"user_id" => ["can't be blank"]}
    end
  end
end
