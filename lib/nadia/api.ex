defmodule Nadia.API do
  @moduledoc """
  Provides basic functionalities for Telegram Bot API.
  """

  alias Nadia.Model.Error
  alias Nadia.Config

  @type request_option :: {:token, String.t()}
                        | {:base_url, String.t()}

  @type options :: [request_option]

  @type params :: map

  @doc """
  Generic method to call Telegram Bot API.

  Args:
  * `method` - name of API method
  * `params` - the request parameters
  * `options` - options used for configuring the connection and httpoison
  * `file_field` - specify the key of file_field in `options` when sending files
  """
  @spec request(binary, params, options, atom) :: :ok | {:error, Error.t()} | {:ok, any}
  def request(method, params \\ %{}, options \\ [], file_field \\ nil) do
    method
    |> build_url(options)
    |> HTTPoison.post(build_request(params, file_field), [], build_options(options))
    |> process_response(method)
  end

  @spec request?(binary, params, options, atom) :: term
  def request?(method, params \\ %{}, options \\ [], file_field \\ nil) do
    {_, response} = request(method, params, options, file_field)
    response
  end

  @doc ~S"""
  Use this function to build file url.

  iex> Nadia.API.build_file_url("document/file_10")
  "https://api.telegram.org/file/bot#{Nadia.Config.token()}/document/file_10"
  """
  @spec build_file_url(binary, Keyword.t()) :: binary
  def build_file_url(file_path, options \\ []) do
    Config.file_base_url(options) <> Config.token(options) <> "/" <> file_path
  end

  defp build_url(method, options) do
    Config.base_url(options) <> Config.token(options) <> "/" <> method
  end

  defp process_response(response, method) do
    case decode_response(response) do
      {:ok, true} -> :ok
      {:ok, %{ok: false, description: description}} -> {:error, %Error{reason: description}}
      {:ok, result} -> {:ok, Nadia.Parser.parse_result(result, method)}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, %Error{reason: reason}}
      {:error, error} -> {:error, %Error{reason: error}}
    end
  end

  defp decode_response(response) do
    with {:ok, %HTTPoison.Response{body: body}} <- response,
         {:ok, %{result: result}} <- Jason.decode(body, keys: :atoms),
         do: {:ok, result}
  end

  defp build_request(params, file_field) when is_list(params) do
    params
    |> Keyword.update(:reply_markup, nil, &Jason.encode!(&1))
    |> map_params(file_field)
  end

  defp build_request(params, file_field) when is_map(params) do
    params
    |> Map.update(:reply_markup, nil, &Jason.encode!(&1))
    |> map_params(file_field)
  end

  defp map_params(params, file_field) do
    params =
      params
      |> Enum.filter(fn {_, v} -> v end)
      |> Enum.map(fn {k, v} -> {k, to_string(v)} end)

    if !is_nil(file_field) and File.exists?(params[file_field]) do
      build_multipart_request(params, file_field)
    else
      {:form, params}
    end
  end

  defp build_multipart_request(params, file_field) do
    {file_path, params} = Keyword.pop(params, file_field)
    params = for {k, v} <- params, do: {to_string(k), v}

    {:multipart,
     params ++
       [
         {:file, file_path,
          {"form-data", [{"name", to_string(file_field)}, {"filename", file_path}]}, []}
       ]}
  end

  defp build_options(options) do
    recv_timeout = calculate_recv_timeout(options)

    opts =
      Keyword.take(options, [
        :timeout,
        :hackney,
      ])
      |> Keyword.put(:recv_timeout, recv_timeout)

    opts =
      case Config.proxy(options) do
        proxy when byte_size(proxy) > 0 ->
          Keyword.put(opts, :proxy, proxy)

        proxy when is_tuple(proxy) and tuple_size(proxy) == 3 ->
          Keyword.put(opts, :proxy, proxy)

        _ ->
          opts
      end

    opts =
      case Config.proxy_auth(options) do
        proxy_auth when is_tuple(proxy_auth) and tuple_size(proxy_auth) == 2 ->
          Keyword.put(opts, :proxy_auth, proxy_auth)

        _ ->
          opts
      end

    opts =
      case Config.socks5_user(options) do
        socks5_user when byte_size(socks5_user) > 0 ->
          Keyword.put(opts, :socks5_user, socks5_user)

        _ ->
          opts
      end

    case Config.socks5_pass(options) do
      socks5_pass when byte_size(socks5_pass) > 0 ->
        Keyword.put(opts, :socks5_pass, socks5_pass)

      _ ->
        opts
    end
  end

  defp calculate_recv_timeout(options) do
    Config.recv_timeout(options)
  end
end
