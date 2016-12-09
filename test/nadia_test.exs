defmodule NadiaTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Nadia, only: [get_file_link: 1]
  alias Nadia.Model.User

  setup_all do
    ExVCR.Config.filter_sensitive_data("bot[^/]+/", "bot<TOKEN>/")
    ExVCR.Config.filter_sensitive_data("id\":\\d+", "id\":666")
    ExVCR.Config.filter_sensitive_data("id=\\d+", "id=666")
    ExVCR.Config.filter_sensitive_data("_id=@w+", "_id=@group")
    {:ok, %{token: "TEST_TOKEN"}}
  end

  test "get_me", %{token: token} do
    use_cassette "get_me" do
      {:ok, me} = Nadia.get_me token: token
      assert me == %User{id: 666, first_name: "Nadia", username: "nadia_bot"}
    end
  end

  test "send_message", %{token: token} do
    use_cassette "send_message" do
      {:ok, message} = Nadia.send_message(666, "aloha", token: token)
      assert message.text == "aloha"
    end
  end

  test "forward_message", %{token: token} do
    use_cassette "forward_message" do
      {:ok, message} = Nadia.forward_message(666, 666, 666, token: token)
      refute is_nil(message.forward_date)
      refute is_nil(message.forward_from)
    end
  end

  test "send_photo", %{token: token} do
    use_cassette "send_photo" do
      file_id = "AgADBQADq6cxG7Vg2gSIF48DtOpj4-edszIABGGN5AM6XKzcLjwAAgI"
      {:ok, message} = Nadia.send_photo(666, file_id, token: token)
      assert is_list(message.photo)
      assert Enum.any?(message.photo, &(&1.file_id == file_id))
    end
  end

  test "send_sticker", %{token: token} do
    use_cassette "send_sticker" do
      {:ok, message} = Nadia.send_sticker(666, "BQADBQADBgADmEjsA1aqdSxtzvvVAg", token: token)
      refute is_nil(message.sticker)
      assert message.sticker.file_id == "BQADBQADBgADmEjsA1aqdSxtzvvVAg"
    end
  end

  test "send_contact", %{token: token} do
    use_cassette "send_contact" do
      {:ok, message} = Nadia.send_contact(666, 10123800555, "Test", token: token)
      refute is_nil(message.contact)
      assert message.contact.phone_number == "10123800555"
      assert message.contact.first_name == "Test"
    end
  end

  test "send_location", %{token: token} do
    use_cassette "send_location" do
      {:ok, message} = Nadia.send_location(666, 1, 2, token: token)
      refute is_nil(message.location)
      assert_in_delta message.location.latitude, 1, 1.0e-3
      assert_in_delta message.location.longitude, 2, 1.0e-3
    end
  end

  test "send_venue", %{token: token} do
    use_cassette "send_venue" do
      {:ok, message} = Nadia.send_venue(666, 1, 2, "Test", "teststreet", token: token)
      refute is_nil(message.venue)
      assert_in_delta message.venue.location.latitude, 1, 1.0e-3
      assert_in_delta message.venue.location.longitude, 2, 1.0e-3
      assert message.venue.title == "Test"
      assert message.venue.address == "teststreet"
    end
  end

  test "send_chat_action", %{token: token} do
    use_cassette "send_chat_action" do
      assert Nadia.send_chat_action(666, "typing", token: token) == :ok
    end
  end

  test "get_user_profile_photos", %{token: token} do
    use_cassette "get_user_profile_photos" do
      {:ok, user_profile_photos} = Nadia.get_user_profile_photos(666, token: token)
      assert user_profile_photos.total_count == 1
      refute is_nil(user_profile_photos.photos)
    end
  end

  test "get_updates", %{token: token} do
    use_cassette "get_updates" do
      {:ok, updates} = Nadia.get_updates(limit: 1, token: token)
      assert length(updates) == 1
    end
  end

  test "set webhook", %{token: token} do
    use_cassette "set_webhook" do
      assert Nadia.set_webhook(url: "https://telegram.org/", token: token) == :ok
    end
  end

  test "delete webhook", %{token: token} do
    use_cassette "delete_webhook" do
      assert Nadia.delete_webhook(token: token) == :ok
    end
  end

  test "get_file", %{token: token} do
    use_cassette "get_file" do
      {:ok, file} = Nadia.get_file("BQADBQADBgADmEjsA1aqdSxtzvvVAg", token: token)
      refute is_nil(file.file_path)
      assert file.file_id == "BQADBQADBgADmEjsA1aqdSxtzvvVAg"
    end
  end

  test "get_chat", %{token: token} do
    use_cassette "get_chat" do
      {:ok, chat} = Nadia.get_chat("@group", token: token)
      assert chat.username == "group"
    end
  end

  test "get_chat_member", %{token: token} do
    use_cassette "get_chat_member" do
      {:ok, chat_member} = Nadia.get_chat_member("@group", 666, token: token)
      assert chat_member.user.username == "nadia_bot"
      assert chat_member.status == "member"
    end
  end

  test "get_chat_administrators", %{token: token} do
    use_cassette "get_chat_administrators" do
      {:ok, [admin | [creator]]} = Nadia.get_chat_administrators("@group", token: token)
      assert admin.status == "administrator"
      assert admin.user.username == "nadia_bot"
      assert creator.status == "creator"
      assert creator.user.username == "group_creator"
    end
  end

  test "get_chat_members_count", %{token: token} do
    use_cassette "get_chat_members_count" do
      {:ok, count} = Nadia.get_chat_members_count("@group", token: token)
      assert count == 2
    end
  end

  test "leave_chat", %{token: token} do
    use_cassette "leave_chat" do
      assert Nadia.leave_chat("@group", token: token) == :ok
    end
  end

  test "answer_inline_query", %{token: token} do
    photo = %Nadia.Model.InlineQueryResult.Photo{id: "1", photo_url: "http://vignette1.wikia.nocookie.net/cardfight/images/5/53/Monokuma.jpg/revision/latest?cb=20130928103410", thumb_url: "http://vignette1.wikia.nocookie.net/cardfight/images/5/53/Monokuma.jpg/revision/latest?cb=20130928103410"}
    use_cassette "answer_inline_query" do
      assert :ok == Nadia.answer_inline_query(666, [photo], token: token)
    end
  end
end
