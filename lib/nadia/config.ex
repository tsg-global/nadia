defmodule Nadia.Config do
  @default_timeout 5
  @default_base_url "https://api.telegram.org/bot"
  @default_graph_base_url "https://api.telegra.ph"
  @default_file_base_url "https://api.telegram.org/file/bot"

  def token(options \\ []), do: get(:token, options)

  def proxy(options \\ []), do: get(:proxy, options)

  def proxy_auth(options \\ []), do: get(:proxy_auth, options)

  def socks5_user(options \\ []), do: get(:socks5_user, options)

  def socks5_pass(options \\ []), do: get(:socks5_pass, options)

  def recv_timeout(options \\ []), do: get(:recv_timeout, options, @default_timeout)

  def base_url(options \\ []), do: get(:base_url, options, @default_base_url)

  def graph_base_url(options \\ []), do: get(:graph_base_url, options, @default_graph_base_url)

  def file_base_url(options \\ []), do: get(:file_base_url, options, @default_file_base_url)

  defp get(key, options, default \\ nil)

  defp get(key, options, default) when is_map(options) do
    case Map.fetch(options, key) do
      {:ok, value} ->
        value

      :error ->
        config_or_env(key, default)
    end
  end

  defp get(key, options, default) when is_list(options) do
    case Keyword.fetch(options, key) do
      {:ok, value} ->
        value

      :error ->
        config_or_env(key, default)
    end
  end

  defp config_or_env(key, default) do
    case Application.fetch_env(:nadia, key) do
      {:ok, {:system, var}} ->
        System.get_env(var)

      {:ok, {:system, var, sys_default}} ->
        case System.get_env(var) do
          nil ->
            sys_default

          val ->
            val
        end

      {:ok, value} ->
        value

      :error ->
        default
    end
  end
end
