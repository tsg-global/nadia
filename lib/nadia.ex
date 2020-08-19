defmodule Nadia do
  @moduledoc """
  Provides access to Telegram Bot API.

  ## Reference
  https://core.telegram.org/bots/api#available-methods
  """

  alias Nadia.Model.{User, Message, Update, UserProfilePhotos, File, Error, WebhookInfo}

  import Nadia.API
  import Nadia.Utils

  @api_version "2.3.1"

  @behaviour Nadia.Behaviour

  @type options :: Nadia.API.options()

  @type params :: Nadia.API.params()

  def api_version do
    @api_version
  end

  @doc """
  A simple method for testing your bot's auth token. Requires no parameters.
  Returns basic information about the bot in form of a User object.

  Args:
  * `options` - request options
  """
  @spec get_me(params(), options()) :: {:ok, User.t()} | {:error, Error.t()}
  def get_me(params \\ %{}, options \\ []), do: request("getMe", params, options)

  @doc """
  Use this method to send text messages.
  On success, the sent Message is returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `text` - Text of the message to be sent
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:parse_mode` - Use `Markdown`, if you want Telegram apps to show bold, italic
  and inline URLs in your bot's message
  * `:disable_web_page_preview` - Disables link previews for links in this message
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_message(integer | binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_message(chat_id, text, params, options \\ []) do
    request("sendMessage", any_map_merge([chat_id: chat_id, text: text], params), options)
  end

  @doc """
  Use this method to forward messages of any kind.
  On success, the sent Message is returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `from_chat_id` - Unique identifier for the chat where the original message was sent
  or username of the target channel (in the format @channelusername)
  * `:disable_notification` - Sends the message silently or without notification
  * `message_id` - Unique message identifier
  * `params` - additional request parameters
  * `options` - request options
  """
  @spec forward_message(integer | binary, integer | binary, integer, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def forward_message(chat_id, from_chat_id, message_id, params \\ %{}, options \\ []) do
    request(
      "forwardMessage",
      any_map_merge([
        chat_id: chat_id,
        from_chat_id: from_chat_id,
        message_id: message_id
      ], params),
      options
    )
  end

  @doc """
  Use this method to send photos.
  On success, the sent Message is returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `photo` - Photo to send. Either a `file_id` to resend a photo that is already on
  the Telegram servers, or a `file_path` to upload a new photo
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:caption` - Photo caption (may also be used when resending photos by `file_id`)
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_photo(integer | binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_photo(chat_id, photo, params \\ %{}, options \\ []) do
    request("sendPhoto", any_map_merge([chat_id: chat_id, photo: photo], params), options, :photo)
  end

  @doc """
  Use this method to send audio files, if you want Telegram clients to display
  them in the music player. Your audio must be in the .mp3 format.
  On success, the sent Message is returned.
  Bots can currently send audio files of up to 50 MB in size, this limit may
  be changed in the future.

  For backward compatibility, when the fields title and performer are both
  empty and the mime-type of the file to be sent is not audio/mpeg, the file
  will be sent as a playable voice message. For this to work, the audio must be
  in an .ogg file encoded with OPUS. This behavior will be phased out in the
  future. For sending voice messages, use the sendVoice method instead.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `audio` - Audio to send. Either a `file_id` to resend an audio that is already on
  the Telegram servers, or a `file_path` to upload a new audio
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:duration` - Duration of the audio in seconds
  * `:performer` - Performer
  * `:title` - Track name
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_audio(integer | binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_audio(chat_id, audio, params \\ %{}, options \\ []) do
    request("sendAudio",
            any_map_merge([chat_id: chat_id, audio: audio], params),
            options,
            :audio)
  end

  @doc """
  Use this method to send general files.
  On success, the sent Message is returned.
  Bots can currently send files of any type of up to 50 MB in size, this limit
  may be changed in the future.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `document` - File to send. Either a `file_id` to resend a file that is already on
  the Telegram servers, or a `file_path` to upload a new file
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_document(integer | binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_document(chat_id, document, params, options \\ []) do
    request("sendDocument",
            any_map_merge([chat_id: chat_id, document: document], params),
            options,
            :document)
  end

  @doc """
  Use this method to send .webp stickers.
  On success, the sent Message is returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `sticker` - File to send. Either a `file_id` to resend a sticker that is already on
  the Telegram servers, or a `file_path` to upload a new sticker
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_sticker(integer | binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_sticker(chat_id, sticker, params, options \\ []) do
    request("sendSticker",
            any_map_merge([chat_id: chat_id, sticker: sticker], params),
            options,
            :sticker)
  end

  @doc """
  Use this method to send video files, Telegram clients support mp4 videos
  (other formats may be sent as Document).
  On success, the sent Message is returned.
  Bots can currently send video files of up to 50 MB in size, this limit may be
  changed in the future.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `video` - Video to send. Either a `file_id` to resend a video that is already on
  the Telegram servers, or a `file_path` to upload a new video
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:duration` - Duration of the video in seconds
  * `:caption` - Video caption (may also be used when resending videos by `file_id`)
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_video(integer | binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_video(chat_id, video, params \\ %{}, options \\ []) do
    request("sendVideo",
            any_map_merge([chat_id: chat_id, video: video], params),
            options,
            :video)
  end

  @doc """
  Use this method to send audio files, if you want Telegram clients to display
  the file as a playable voice message. For this to work, your audio must be in
  an .ogg file encoded with OPUS (other formats may be sent as Audio or Document).
  On success, the sent Message is returned.
  Bots can currently send voice messages of up to 50 MB in size, this limit may be
  changed in the future.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `voice` - Audio to send. Either a `file_id` to resend an audio that is already on
  the Telegram servers, or a `file_path` to upload a new audio
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:duration` - Duration of the audio in seconds
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_voice(integer | binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_voice(chat_id, voice, params \\ %{}, options \\ []) do
    request("sendVoice",
            any_map_merge([chat_id: chat_id, voice: voice], params),
            options,
            :voice)
  end

  @doc """
  Use this method to send point on the map.
  On success, the sent Message is returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `latitude` - Latitude of location
  * `longitude` - Longitude of location
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. Instructions to hide keyboard or to
  force a reply from the user - `Nadia.Model.ReplyKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardRemove` or `Nadia.Model.ForceReply`
  """
  @spec send_location(integer | binary, float, float, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_location(chat_id, latitude, longitude, params \\ %{}, options \\ []) do
    request("sendLocation",
            any_map_merge([chat_id: chat_id, latitude: latitude, longitude: longitude], params),
            options)
  end

  @doc """
  Use this method to send information about a venue.
  On success, the sent Message is returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `latitude` - Latitude of location
  * `longitude` - Longitude of location
  * `title` - Name of the venue
  * `address` - Address of the venue
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:foursquare_id` - Foursquare identifier of the venue
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. A JSON-serialized object for
  an inline keyboard, custom reply keyboard, instructions to hide reply keyboard
  or to force a reply from the user. - `Nadia.Model.InlineKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardMarkup` or `Nadia.Model.ReplyKeyboardRemove` or
  `Nadia.Model.ForceReply`
  """
  @spec send_venue(integer | binary, float, float, binary, binary, [{atom, any}]) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_venue(chat_id, latitude, longitude, title, address, params \\ %{}, options \\ []) do
    request("sendVenue",
            any_map_merge([
              chat_id: chat_id,
              latitude: latitude,
              longitude: longitude,
              title: title,
              address: address
            ], params),
            options)
  end

  @doc """
  Use this method to send phone contacts.
  On success, the sent Message is returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `phone_number` - Contact's phone number
  * `first_name` - Contact's first name
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:last_name` - Contact's last name
  * `:disable_notification` - Sends the message silently or without notification
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. A JSON-serialized object for
  an inline keyboard, custom reply keyboard, instructions to hide reply keyboard
  or to force a reply from the user. - `Nadia.Model.InlineKeyboardMarkup` or
  `Nadia.Model.ReplyKeyboardMarkup` or `Nadia.Model.ReplyKeyboardRemove` or
  `Nadia.Model.ForceReply`
  """
  @spec send_contact(integer | binary, binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_contact(chat_id, phone_number, first_name, params \\ %{}, options \\ []) do
    request(
      "sendContact",
      any_map_merge([chat_id: chat_id, phone_number: phone_number, first_name: first_name], params),
      options
    )
  end

  @doc """
  Use this method when you need to tell the user that something is happening on
  the bot's side. The status is set for 5 seconds or less (when a message
  arrives from your bot, Telegram clients clear its typing status).

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `action` - Type of action to broadcast. Choose one, depending on what the user is
  about to receive:
      * `typing` for text messages
      * `upload_photo` for photos
      * `record_video` or `upload_video` for videos
      * `record_audio` or `upload_audio` for audio files
      * `upload_document` for general files
      * `find_location` for location data
  * `params` - additional request parameters
  * `options` - request options
  """
  @spec send_chat_action(integer | binary, binary) :: :ok | {:error, Error.t()}
  def send_chat_action(chat_id, action, params \\ %{}, options \\ []) do
    request("sendChatAction", any_map_merge([chat_id: chat_id, action: action], params), options)
  end

  @doc """
  Use this method to send animation files (GIF or H.264/MPEG-4 AVC video without sound).
  On success, the sent Message is returned. Bots can currently send animation files of up
  to 50 MB in size, this limit may be changed in the future.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `animation` - Animation to send. Pass a file_id as String to send an animation that
  exists on the Telegram servers (recommended), pass an HTTP URL as a String for
  Telegram to get an animation from the Internet, or upload a new animation using multipart/form-data.
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:duration` - Duration of sent animation in seconds
  * `:width` - Animation width
  * `:height` - Animation height
  * `:thumb` - Thumbnail of the file sent; can be ignored if thumbnail generation for the file
  is supported server-side. thumbnail should be in JPEG format and less than 200 kB in size.
  * `:caption` - Animation caption (may also be used when resending animation by file_id), 0-1024 characters
  * `:parse_mode` - Send Markdown or HTML, if you want Telegram apps to show bold, italic, fixed-width
  text or inline URLs in the media caption.
  * `:disable_notification` - Sends the message silently. Users will receive a notification with no sound.
  * `:reply_to_message_id` - If the message is a reply, ID of the original message
  * `:reply_markup` - Additional interface options. A JSON-serialized object for an inline keyboard,
  custom reply keyboard, instructions to remove reply keyboard or to force a reply from the user.
  """
  @spec send_animation(integer | binary, binary, [{atom, any}]) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def send_animation(chat_id, animation, params \\ %{}, options \\ []) do
    request("sendAnimation",
            any_map_merge([chat_id: chat_id, animation: animation], params),
            options)
  end

  @doc """
  Use this method to get a list of profile pictures for a user.
  Returns a UserProfilePhotos object.

  Args:
  * `user_id` - Unique identifier of the target user
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:offset` - Sequential number of the first photo to be returned. By default, all
  photos are returned
  * `:limit` - Limits the number of photos to be retrieved. Values between 1—100 are
  accepted. Defaults to 100
  """
  @spec get_user_profile_photos(integer, params(), options()) ::
          {:ok, UserProfilePhotos.t()} | {:error, Error.t()}
  def get_user_profile_photos(user_id, params \\ %{}, options \\ []) do
    request("getUserProfilePhotos", any_map_merge([user_id: user_id], params), options)
  end

  @doc """
  Use this method to receive incoming updates using long polling.
  An Array of Update objects is returned.

  Args:
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:offset` - Identifier of the first update to be returned. Must be greater by one
  than the highest among the identifiers of previously received updates. By default,
  updates starting with the earliest unconfirmed update are returned. An update is
  considered confirmed as soon as `get_updates` is called with an `offset` higher than
  its `update_id`.
  * `:limit` - Limits the number of updates to be retrieved. Values between 1—100 are
  accepted. Defaults to 100
  * `:timeout` - Timeout in seconds for long polling. Defaults to 0, i.e. usual short
  polling
  """
  @spec get_updates(params(), options()) :: {:ok, [Update.t()]} | {:error, Error.t()}
  def get_updates(params \\ %{}, options \\ []) do
    request("getUpdates", params, options)
  end

  @doc """
  Use this method to specify a url and receive incoming updates via an outgoing
  webhook. Whenever there is an update for the bot, we will send an HTTPS POST
  request to the specified url, containing a JSON-serialized Update. In case of
  an unsuccessful request, we will give up after a reasonable amount of attempts.

  Args:
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:url` - HTTPS url to send updates to.
  """
  @spec set_webhook(params(), options()) :: :ok | {:error, Error.t()}
  def set_webhook(params \\ %{}, options \\ []) do
    request("setWebhook", params, options)
  end

  @doc """
  Use this method to remove webhook integration if you decide to switch back to `Nadia.get_updates/1`.
  Returns `:ok` on success.

  Args:
  * `params` - request parameters
  * `options` - request options
  """
  @spec delete_webhook(params(), options()) :: :ok | {:error, Error.t()}
  def delete_webhook(params \\ %{}, options \\ []) do
    request("deleteWebhook", params, options)
  end

  @doc """
  Use this method to get current webhook status. Requires no parameters.
  On success, returns a `Nadia.Model.WebhookInfo.t()` object with webhook details.
  If the bot is using getUpdates, will return an object with the url field empty.

  Args:
  * `params` - request parameters
  * `options` - request options
  """
  @spec get_webhook_info(params(), options()) :: {:ok, WebhookInfo.t()} | {:error, Error.t()}
  def get_webhook_info(params \\ %{}, options \\ []) do
    request("getWebhookInfo", params, options)
  end

  @doc """
  Use this method to get basic info about a file and prepare it for downloading.
  For the moment, bots can download files of up to 20MB in size.
  On success, a File object is returned.
  The file can then be downloaded via the link
  `https://api.telegram.org/file/bot<token>/<file_path>`, where <file_path> is taken
  from the response. It is guaranteed that the link will be valid for at least 1 hour.
  When the link expires, a new one can be requested by calling `get_file` again.

  Args:
  * `file_id` - File identifier to get info about
  * `params` - request parameters
  * `options` - request options
  """
  @spec get_file(binary, params(), options()) :: {:ok, File.t()} | {:error, Error.t()}
  def get_file(file_id, params \\ %{}, options \\ []) do
    request("getFile", any_map_merge([file_id: file_id], params), options)
  end

  @doc """
  Use this method to get link for file for subsequent use.
  This method is an extension of the `get_file` method.

      iex> Nadia.get_file_link(%Nadia.Model.File{file_id: "BQADBQADBgADmEjsA1aqdSxtzvvVAg",
      ...> file_path: "document/file_10", file_size: 17680})
      {:ok,
      "https://api.telegram.org/file/bot#{Nadia.Config.token([])}/document/file_10"}

  Args:
  * `file` - the file to build the url for
  * `options` - options containing the token
  """
  @spec get_file_link(File.t(), options()) :: {:ok, binary} | {:error, Error.t()}
  def get_file_link(file, options \\ []) do
    {:ok, build_file_url(file.file_path, options)}
  end

  @doc """
  Use this method to kick a user from a group or a supergroup. In the case of supergroups,
  the user will not be able to return to the group on their own using invite links, etc.,
  unless unbanned first. The bot must be an administrator in the group for this to work.
  Returns True on success.

  Note: This will method only work if the ‘All Members Are Admins’ setting is off in the
  target group. Otherwise members may only be removed by the group's creator or by the
  member that added them.

  Args:
  * `chat_id` - Unique identifier for the target group or username of the target supergroup
  (in the format @supergroupusername)
  * `user_id` - Unique identifier of the target user
  * `params` - request parameters
  * `options` - request options
  """
  @spec kick_chat_member(integer | binary, integer, params(), options()) ::
          :ok | {:error, Error.t()}
  def kick_chat_member(chat_id, user_id, params \\ %{}, options \\ []) do
    request("kickChatMember",
            any_map_merge([chat_id: chat_id, user_id: user_id], params),
            options)
  end

  @doc """
  Use this method for your bot to leave a group, supergroup or channel.
  Returns True on success.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target supergroup or
  channel (in the format @supergroupusername)
  * `params` - request parameters
  * `options` - request options
  """
  @spec leave_chat(integer | binary, params(), options()) :: :ok | {:error, Error.t()}
  def leave_chat(chat_id, params \\ %{}, options \\ []) do
    request("leaveChat",
            any_map_merge([chat_id: chat_id], params),
            options)
  end

  @doc """
  Use this method to unban a previously kicked user in a supergroup. The user will not
  return to the group automatically, but will be able to join via link, etc. The bot
  must be an administrator in the group for this to work. Returns True on success.

  Args:
  * `chat_id` - Unique identifier for the target group or username of the target supergroup
  (in the format @supergroupusername)
  * `user_id` - Unique identifier of the target user
  * `params` - request parameters
  * `options` - request options
  """
  @spec unban_chat_member(integer | binary, integer, params(), options()) ::
          :ok | {:error, Error.t()}
  def unban_chat_member(chat_id, user_id, params \\ %{}, options \\ []) do
    request("unbanChatMember",
            any_map_merge([chat_id: chat_id, user_id: user_id], params),
            options)
  end

  @doc """
  Use this method to get up to date information about the chat (current name of
  the user for one-on-one conversations, current username of a user, group or channel, etc.)
  Returns a Chat object on success.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target supergroup or
  channel (in the format @supergroupusername)
  * `params` - request parameters
  * `options` - request options
  """
  @spec get_chat(integer | binary, params(), options()) :: {:ok, Chat.t()} | {:error, Error.t()}
  def get_chat(chat_id, params \\ %{}, options \\ []) do
    request("getChat", any_map_merge([chat_id: chat_id], params), options)
  end

  @doc """
  Use this method to get a list of administrators in a chat. On success, returns an Array of
  ChatMember objects that contains information about all chat administrators except other bots.
  If the chat is a group or a supergroup and no administrators were appointed, only the creator
  will be returned.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target supergroup or
  channel (in the format @channelusername)
  * `params` - request parameters
  * `options` - request options
  """
  @spec get_chat_administrators(integer | binary, params(), options()) ::
          {:ok, [ChatMember.t()]} | {:error, Error.t()}
  def get_chat_administrators(chat_id, params \\ %{}, options \\ []) do
    request("getChatAdministrators", any_map_merge([chat_id: chat_id], params), options)
  end

  @doc """
  Use this method to get the number of members in a chat. Returns Int on success.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target supergroup or
  channel (in the format @channelusername)
  * `params` - request parameters
  * `options` - request options
  """
  @spec get_chat_members_count(integer | binary, params(), options()) ::
          {:ok, integer} | {:error, Error.t()}
  def get_chat_members_count(chat_id, params \\ %{}, options \\ []) do
    request("getChatMembersCount",
            any_map_merge([chat_id: chat_id], params),
            options)
  end

  @doc """
  Use this method to get information about a member of a chat.
  Returns a ChatMember object on success.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target supergroup or
  channel (in the format @channelusername)
  * `user_id` - Unique identifier of the target user
  * `params` - request parameters
  * `options` - request options
  """
  @spec get_chat_member(integer | binary, integer, params(), options()) ::
          {:ok, ChatMember.t()} | {:error, Error.t()}
  def get_chat_member(chat_id, user_id, params \\ %{}, options \\ []) do
    request("getChatMember", any_map_merge([chat_id: chat_id, user_id: user_id], params), options)
  end

  @doc """
  Use this method to send answers to callback queries sent from inline keyboards.
  The answer will be displayed to the user as a notification at the top of the chat
  screen or as an alert. On success, True is returned.

  Args:
  * `callback_query_id` - Unique identifier for the query to be answered
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:text` - Text of the notification. If not specified, nothing will be shown
  to the user
  * `:show_alert` - If true, an alert will be shown by the client instead of a
  notification at the top of the chat screen. Defaults to false.
  """
  @spec answer_callback_query(binary, params(), options()) :: :ok | {:error, Error.t()}
  def answer_callback_query(callback_query_id, params \\ %{}, options \\ []) do
    request("answerCallbackQuery",
            any_map_merge([callback_query_id: callback_query_id], params),
            options)
  end

  @doc """
  Use this method to edit text messages sent by the bot or via the bot (for inline bots).
  On success, the edited Message is returned

  Args:
  * `chat_id` - Required if inline_message_id is not specified. Unique identifier
  for the target chat or username of the target channel (in the format @channelusername)
  * `message_id` - Required if inline_message_id is not specified. Unique identifier of
  the sent message
  * `inline_message_id` - Required if `chat_id` and `message_id` are not specified.
  Identifier of the inline message
  * `text` - New text of the message
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:parse_mode`	- Send Markdown or HTML, if you want Telegram apps to show bold, italic,
                    fixed-width text or inline URLs in your bot's message.
  * `:disable_web_page_preview` - Disables link previews for links in this message
  * `:reply_markup` - A JSON-serialized object for an inline
  keyboard - `Nadia.Model.InlineKeyboardMarkup`
  """
  @spec edit_message_text(integer | binary, integer, binary, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def edit_message_text(chat_id, message_id, inline_message_id, text, params \\ %{},
                                                                      options \\ []) do
    request("editMessageText",
            any_map_merge([
              chat_id: chat_id,
              message_id: message_id,
              inline_message_id: inline_message_id,
              text: text
            ], params),
            options)
  end

  @doc """
  Use this method to delete message from a chat.
  Bot should have admin permission to do that, and remember you can't delete messages that are more than
  48 hours old.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `message_id` - Required if inline_message_id is not specified. Unique identifier of
  the sent message
  * `params` - request parameters
  * `options` - request options
  """
  @spec delete_message(integer | binary, integer, params(), options()) :: :ok | {:error, Error.t()}
  def delete_message(chat_id, message_id, params \\ %{}, options \\ []) do
    request("deleteMessage",
            any_map_merge([chat_id: chat_id, message_id: message_id], params),
            options)
  end

  @doc """
  Use this method to edit captions of messages sent by the bot or via
  the bot (for inline bots). On success, the edited Message is returned.

  Args:
  * `chat_id` - Required if inline_message_id is not specified. Unique identifier
  for the target chat or username of the target channel (in the format @channelusername)
  * `message_id` - Required if inline_message_id is not specified. Unique identifier of
  the sent message
  * `inline_message_id` - Required if `chat_id` and `message_id` are not specified.
  Identifier of the inline message
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:caption` - New caption of the message
  * `:reply_markup` - A JSON-serialized object for an inline
  keyboard - `Nadia.Model.InlineKeyboardMarkup`
  """
  @spec edit_message_caption(integer | binary, integer, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def edit_message_caption(chat_id, message_id, inline_message_id, params \\ %{}, options \\ []) do
    request("editMessageCaption",
            any_map_merge([
              chat_id: chat_id,
              message_id: message_id,
              inline_message_id: inline_message_id
            ], params),
            options)
  end

  @doc """
  Use this method to edit only the reply markup of messages sent by the bot or via
  the bot (for inline bots). On success, the edited Message is returned.

  Args:
  * `chat_id` - Required if inline_message_id is not specified. Unique identifier
  for the target chat or username of the target channel (in the format @channelusername)
  * `message_id` - Required if inline_message_id is not specified. Unique identifier of
  the sent message
  * `inline_message_id` - Required if `chat_id` and `message_id` are not specified.
  Identifier of the inline message
  * `params` - request parameters
  * `options` - request options

  Params:
  * `:reply_markup`	- A JSON-serialized object for an inline
  keyboard - `Nadia.Model.InlineKeyboardMarkup`
  """
  @spec edit_message_reply_markup(integer | binary, integer, binary, params(), options()) ::
          {:ok, Message.t()} | {:error, Error.t()}
  def edit_message_reply_markup(chat_id, message_id, inline_message_id, params \\ %{},
                                                                        options \\ []) do
    request("editMessageReplyMarkup",
            any_map_merge([
              chat_id: chat_id,
              message_id: message_id,
              inline_message_id: inline_message_id
            ], params),
            options)
  end

  @doc """
  Use this method to send answers to an inline query. On success, True is returned.
  No more than 50 results per query are allowed.

  Args:
  * `inline_query_id` - Unique identifier for the answered query
  * `results` - An array of results for the inline query
  * `params` - request parameters
  * `options` - request options

  Params:
  * `cache_time` - The maximum amount of time in seconds that the result of the inline
  query may be cached on the server. Defaults to 300.
  * `is_personal` - Pass True, if results may be cached on the server side only for
  the user that sent the query. By default, results may be returned to any user who
  sends the same query
  * `next_offset` - Pass the offset that a client should send in the next query with
  the same text to receive more results. Pass an empty string if there are no more
  results or if you don‘t support pagination. Offset length can’t exceed 64 bytes.
  * `switch_pm_text` - If passed, clients will display a button with specified text
  that switches the user to a private chat with the bot and sends the bot a start
  message with the parameter switch_pm_parameter.
  * `switch_pm_parameter` - Parameter for the start message sent to the bot when user
  presses the switch button.
  """
  @spec answer_inline_query(binary, [Nadia.Model.InlineQueryResult.t()], params(), options()) ::
          :ok | {:error, Error.t()}
  def answer_inline_query(inline_query_id, results, params \\ %{}, options \\ []) do
    encoded_results =
      results
      |> Enum.map(fn result ->
        for {k, v} <- Map.from_struct(result), v != nil, into: %{}, do: {k, v}
      end)
      |> Jason.encode!()

    args = [inline_query_id: inline_query_id, results: encoded_results]

    request("answerInlineQuery", any_map_merge(args, params), options)
  end

  @doc """
  Use this method to get a sticker set. On success, a StickerSet object is returned.

  Args:
  * `name` - Name of the sticker set
  * `params` - request parameters
  * `options` - request options
  """
  @spec get_sticker_set(binary, params(), options()) ::
          {:ok, Nadia.Model.StickerSet.t()} | {:error, Error.t()}
  def get_sticker_set(name, params \\ %{}, options \\ []) do
    request("getStickerSet", any_map_merge([name: name], params), options)
  end

  @doc """
  Use this method to upload a .png file with a sticker for later use in
  createNewStickerSet and addStickerToSet methods (can be used multiple times).
  Returns the uploaded File on success.

  Args:
  * `user_id` - User identifier of sticker file owner
  * `png_sticker` - Png image with the sticker, must be up to 512 kilobytes in size,
  dimensions must not exceed 512px, and either width or height must be exactly 512px.
  Either a `file_id` to resend a file that is already on the Telegram servers,
  or a `file_path` to upload a new file from local, or a `HTTP URL` to get a file
  from the internet.
  * `params` - request parameters
  * `options` - request options
  """
  @spec upload_sticker_file(integer, binary, params(), options()) ::
          {:ok, File.t()} | {:error, Error.t()}
  def upload_sticker_file(user_id, png_sticker, params \\ %{}, options \\ []) do
    request("uploadStickerFile",
      any_map_merge([user_id: user_id, png_sticker: png_sticker], params),
      options,
      :png_sticker
    )
  end

  @doc """
  Use this method to create new sticker set owned by a user. The bot will be able to
  edit the created sticker set. Returns True on success.

  Args:
  * `user_id` - User identifier of created sticker set owner
  * `name` - Short name of sticker set, to be used in t.me/addstickers/ URLs (e.g., animals).
  Can contain only english letters, digits and underscores. Must begin with a letter,
  can't contain consecutive underscores and must end in “_by_<bot username>”. <bot_username>
  is case insensitive. 1-64 characters.
  * `title` - Sticker set title, 1-64 characters
  * `png_sticker` - Png image with the sticker, must be up to 512 kilobytes in size,
  dimensions must not exceed 512px, and either width or height must be exactly 512px.
  Either a `file_id` to resend a file that is already on the Telegram servers,
  or a `file_path` to upload a new file from local, or a `HTTP URL` to get a file
  from the internet.
  * `emojis` - One or more emoji corresponding to the sticker
  * `params` - request parameters
  * `options` - request options

  Params:
  * `contains_masks` - Pass True, if a set of mask stickers should be created
  * `mask_position` - A `Nadia.Model.MaskPosition` object for position where the mask
  should be placed on faces
  """
  @spec create_new_sticker_set(integer, binary, binary, binary, binary, params(), options()) ::
          :ok | {:error, Error.t()}
  def create_new_sticker_set(user_id, name, title, png_sticker, emojis, params \\ %{},
                                                                        options \\ []) do
    request(
      "createNewStickerSet",
      any_map_merge([
        user_id: user_id,
        name: name,
        title: title,
        png_sticker: png_sticker,
        emojis: emojis
      ], params),
      options,
      :png_sticker
    )
  end

  @doc """
  Use this method to add a new sticker to a set created by the bot. Returns True on success.

  Args:
  * `user_id` - User identifier of created sticker set owner
  * `name` - Sticker set name
  * `png_sticker` - Png image with the sticker, must be up to 512 kilobytes in size,
  dimensions must not exceed 512px, and either width or height must be exactly 512px.
  Either a `file_id` to resend a file that is already on the Telegram servers,
  or a `file_path` to upload a new file from local, or a `HTTP URL` to get a file
  from the internet.
  * `emojis` - One or more emoji corresponding to the sticker
  * `params` - request parameters
  * `options` - request options

  Params:
  * `mask_position` - A `Nadia.Model.MaskPosition` object for position where the mask
  should be placed on faces
  """
  @spec add_sticker_to_set(integer, binary, binary, binary, params(), options()) ::
          :ok | {:error, Error.t()}
  def add_sticker_to_set(user_id, name, png_sticker, emojis, params \\ %{}, options \\ []) do
    request("addStickerToSet",
            any_map_merge([
              user_id: user_id,
              name: name,
              png_sticker: png_sticker,
              emojis: emojis
            ], params),
            options,
            :png_sticker)
  end

  @doc """
  Use this method to move a sticker in a set created by the bot to a specific position.
  Returns True on success.

  Args:
  * `sticker` - File identifier of the sticker
  * `position` - New sticker position in the set, zero-based
  * `params` - request parameters
  * `options` - request options
  """
  @spec set_sticker_position_in_set(binary, integer, params(), options()) ::
          :ok | {:error, Error.t()}
  def set_sticker_position_in_set(sticker, position, params \\ %{}, options \\ []) do
    request("setStickerPositionInSet",
            any_map_merge([sticker: sticker, position: position], params),
            options)
  end

  @doc """
  Use this method to delete a sticker from a set created by the bot. Returns True on success.

  Args:
  * `sticker` - File identifier of the sticker
  * `params` - request parameters
  * `options` - request options
  """
  @spec delete_sticker_from_set(binary, params(), options()) :: :ok | {:error, Error.t()}
  def delete_sticker_from_set(sticker, params \\ %{}, options \\ []) do
    request("deleteStickerFromSet",
            any_map_merge([sticker: sticker], params),
            options)
  end

  @doc """
  Use this method to pin a message in a group, a supergroup, or a channel. The bot must be an
  administrator in the chat for this to work and must have the ‘can_pin_messages’ admin right
  in the supergroup or ‘can_edit_messages’ admin right in the channel. Returns True on success.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `message_id` - Identifier of a message to pin
  * `params` - request parameters
  * `options` - request options

  Params:
  * `disable_notification` - Pass True, if it is not necessary to send a notification to all
  chat members about the new pinned message. Notifications are always disabled in channels.
  """
  @spec pin_chat_message(integer | binary, integer | binary, params(), options()) ::
          :ok | {:error, Error.t()}
  def pin_chat_message(chat_id, message_id, params \\ %{}, options \\ []) do
    request("pinChatMessage",
            any_map_merge([chat_id: chat_id, message_id: message_id], params),
            options)
  end

  @doc """
  Use this method to unpin a message in a group, a supergroup, or a channel. The bot must be an
  administrator in the chat for this to work and must have the ‘can_pin_messages’ admin right in
  the supergroup or ‘can_edit_messages’ admin right in the channel. Returns True on success.

  Args:
  * `chat_id` - Unique identifier for the target chat or username of the target channel
  (in the format @channelusername)
  * `params` - request parameters
  * `options` - request options
  """
  @spec unpin_chat_message(integer | binary, params(), options()) :: :ok | {:error, Error.t()}
  def unpin_chat_message(chat_id, params \\ %{}, options \\ []) do
    request("unpinChatMessage", any_map_merge([chat_id: chat_id], params), options)
  end
end
