defmodule Nadia.Utils do
  @doc """
  Merges Keyword lists or Maps together to form a Keyword list
  """
  @spec any_list_merge(term, term) :: Keyword.t()
  def any_list_merge(a, b) when is_map(a) do
    any_list_merge(Map.to_list(a), b)
  end

  def any_list_merge(a, b) when is_map(b) do
    any_list_merge(a, Map.to_list(b))
  end

  def any_list_merge(a, b) when is_list(a) and is_list(b) do
    Keyword.merge(a, b)
  end

  @doc """
  Merges Keyword lists or Maps together to form a Map
  """
  @spec any_map_merge(term, term) :: Keyword.t()
  def any_map_merge(a, b) when is_list(a) do
    any_map_merge(Enum.into(a, %{}), b)
  end

  def any_map_merge(a, b) when is_list(b) do
    any_map_merge(a, Enum.into(b, %{}))
  end

  def any_map_merge(a, b) when is_map(a) and is_map(b) do
    Map.merge(a, b)
  end
end
