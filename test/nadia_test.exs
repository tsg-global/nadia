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
    {:ok, bot} = Nadia.start_link([token: "TEST_TOKEN"])
    {:ok, %{bot: bot}}
  end

  test "get_me", %{bot: bot_pid} do
    use_cassette "get_me" do
      {:ok, me} = Nadia.get_me bot_pid
      assert me == %User{id: 666, first_name: "Nadia", username: "nadia_bot"}
    end
  end

  test "send_message", %{bot: bot_pid} do
    use_cassette "send_message" do
      {:ok, message} = Nadia.send_message(bot_pid, 666, "aloha")
      assert message.text == "aloha"
    end
  end

  test "forward_message", %{bot: bot_pid} do
    use_cassette "forward_message" do
      {:ok, message} = Nadia.forward_message(bot_pid, 666, 666, 666)
      refute is_nil(message.forward_date)
      refute is_nil(message.forward_from)
    end
  end

  test "send_photo", %{bot: bot_pid} do
    use_cassette "send_photo" do
      file_id = "AgADBQADq6cxG7Vg2gSIF48DtOpj4-edszIABGGN5AM6XKzcLjwAAgI"
      {:ok, message} = Nadia.send_photo(bot_pid, 666, file_id)
      assert is_list(message.photo)
      assert Enum.any?(message.photo, &(&1.file_id == file_id))
    end
  end

  test "send_sticker", %{bot: bot_pid} do
    use_cassette "send_sticker" do
      {:ok, message} = Nadia.send_sticker(bot_pid, 666, "BQADBQADBgADmEjsA1aqdSxtzvvVAg")
      refute is_nil(message.sticker)
      assert message.sticker.file_id == "BQADBQADBgADmEjsA1aqdSxtzvvVAg"
    end
  end

  test "send_contact", %{bot: bot_pid} do
    use_cassette "send_contact" do
      {:ok, message} = Nadia.send_contact(bot_pid, 666, 10123800555, "Test")
      refute is_nil(message.contact)
      assert message.contact.phone_number == "10123800555"
      assert message.contact.first_name == "Test"
    end
  end

  test "send_location", %{bot: bot_pid} do
    use_cassette "send_location" do
      {:ok, message} = Nadia.send_location(bot_pid, 666, 1, 2)
      refute is_nil(message.location)
      assert_in_delta message.location.latitude, 1, 1.0e-3
      assert_in_delta message.location.longitude, 2, 1.0e-3
    end
  end

  test "send_venue", %{bot: bot_pid} do
    use_cassette "send_venue" do
      {:ok, message} = Nadia.send_venue(bot_pid, 666, 1, 2, "Test", "teststreet")
      refute is_nil(message.venue)
      assert_in_delta message.venue.location.latitude, 1, 1.0e-3
      assert_in_delta message.venue.location.longitude, 2, 1.0e-3
      assert message.venue.title == "Test"
      assert message.venue.address == "teststreet"
    end
  end

  test "send_chat_action", %{bot: bot_pid} do
    use_cassette "send_chat_action" do
      assert Nadia.send_chat_action(bot_pid, 666, "typing") == :ok
    end
  end

  test "get_user_profile_photos", %{bot: bot_pid} do
    use_cassette "get_user_profile_photos" do
      {:ok, user_profile_photos} = Nadia.get_user_profile_photos(bot_pid, 666)
      assert user_profile_photos.total_count == 1
      refute is_nil(user_profile_photos.photos)
    end
  end

  test "get_updates", %{bot: bot_pid} do
    use_cassette "get_updates" do
      {:ok, updates} = Nadia.get_updates(bot_pid, limit: 1)
      assert length(updates) == 1
    end
  end

  test "set webhook", %{bot: bot_pid} do
    use_cassette "set_webhook" do
      assert Nadia.set_webhook(bot_pid, url: "https://telegram.org/") == :ok
    end
  end

  test "delete webhook", %{bot: bot_pid} do
    use_cassette "delete_webhook" do
      assert Nadia.set_webhook(bot_pid) == :ok
    end
  end

  test "get_file", %{bot: bot_pid} do
    use_cassette "get_file" do
      {:ok, file} = Nadia.get_file(bot_pid, "BQADBQADBgADmEjsA1aqdSxtzvvVAg")
      refute is_nil(file.file_path)
      assert file.file_id == "BQADBQADBgADmEjsA1aqdSxtzvvVAg"
    end
  end

  test "get_chat", %{bot: bot_pid} do
    use_cassette "get_chat" do
      {:ok, chat} = Nadia.get_chat(bot_pid, "@group")
      assert chat.username == "group"
    end
  end

  test "get_chat_member", %{bot: bot_pid} do
    use_cassette "get_chat_member" do
      {:ok, chat_member} = Nadia.get_chat_member(bot_pid, "@group", 666)
      assert chat_member.user.username == "nadia_bot"
      assert chat_member.status == "member"
    end
  end

  test "get_chat_administrators", %{bot: bot_pid} do
    use_cassette "get_chat_administrators" do
      {:ok, [admin | [creator]]} = Nadia.get_chat_administrators(bot_pid, "@group")
      assert admin.status == "administrator"
      assert admin.user.username == "nadia_bot"
      assert creator.status == "creator"
      assert creator.user.username == "group_creator"
    end
  end

  test "get_chat_members_count", %{bot: bot_pid} do
    use_cassette "get_chat_members_count" do
      {:ok, count} = Nadia.get_chat_members_count(bot_pid, "@group")
      assert count == 2
    end
  end

  test "leave_chat", %{bot: bot_pid} do
    use_cassette "leave_chat" do
      assert Nadia.leave_chat(bot_pid, "@group") == :ok
    end
  end

  test "answer_inline_query", %{bot: bot_pid} do
    photo = %Nadia.Model.InlineQueryResult.Photo{id: "1", photo_url: "http://vignette1.wikia.nocookie.net/cardfight/images/5/53/Monokuma.jpg/revision/latest?cb=20130928103410", thumb_url: "http://vignette1.wikia.nocookie.net/cardfight/images/5/53/Monokuma.jpg/revision/latest?cb=20130928103410"}
    use_cassette "answer_inline_query" do
      assert :ok == Nadia.answer_inline_query(bot_pid, 666, [photo])
    end
  end
end
