defmodule Nadia.Behaviour do
  alias Nadia.Model.{User, Message, Update, UserProfilePhotos, File, Error}

  @type options :: Nadia.API.options()

  @type params :: Nadia.API.params()

  @callback get_me(params(), options()) ::
              {:ok, User.t()} | {:error, Error.t()}

  @callback send_message(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback forward_message(integer, integer, integer, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_photo(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_audio(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_document(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_sticker(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_video(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_voice(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_animation(integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_location(integer, float, float, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_venue(integer, float, float, binary, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_contact(integer, binary, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback send_chat_action(integer, binary, params(), options()) ::
              :ok | {:error, Error.t()}

  @callback get_user_profile_photos(integer, params(), options()) ::
              {:ok, UserProfilePhotos.t()} | {:error, Error.t()}

  @callback get_updates(params(), options()) ::
              {:ok, [Update.t()]} | {:error, Error.t()}

  @callback set_webhook(params(), options()) ::
              :ok | {:error, Error.t()}

  @callback get_file(binary, params(), options()) ::
              {:ok, File.t()} | {:error, Error.t()}

  @callback get_file_link(File.t(), options()) ::
              {:ok, binary} | {:error, Error.t()}

  @callback kick_chat_member(integer | binary, integer, params(), options()) ::
              :ok | {:error, Error.t()}

  @callback leave_chat(integer | binary, params(), options()) ::
              :ok | {:error, Error.t()}

  @callback unban_chat_member(integer | binary, integer, params(), options()) ::
              :ok | {:error, Error.t()}

  @callback get_chat(integer | binary, params(), options()) ::
              {:ok, Chat.t()} | {:error, Error.t()}

  @callback get_chat_administrators(integer | binary, params(), options()) ::
              {:ok, [ChatMember.t()]} | {:error, Error.t()}

  @callback get_chat_members_count(integer | binary, params(), options()) ::
              {:ok, integer} | {:error, Error.t()}

  @callback get_chat_member(integer | binary, integer, params(), options()) ::
              {:ok, ChatMember.t()} | {:error, Error.t()}

  @callback answer_callback_query(binary, params(), options()) ::
              :ok | {:error, Error.t()}

  @callback edit_message_text(integer | binary, integer, binary, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback edit_message_caption(integer | binary, integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback edit_message_reply_markup(integer | binary, integer, binary, params(), options()) ::
              {:ok, Message.t()} | {:error, Error.t()}

  @callback answer_inline_query(binary, [Nadia.Model.InlineQueryResult.t()], params(), options()) ::
              :ok | {:error, Error.t()}
end
