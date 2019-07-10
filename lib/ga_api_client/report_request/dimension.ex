defmodule GaApiClient.ReportRequest.Dimension do
  @doc ~S"""
    Merges dimension into list of dimensions

    iex> GaApiClient.ReportRequest.Dimension.merge([:a, :b], :dim)
    [:a, :b, :dim]
  """
  def merge(list, dimension) when is_atom(dimension) or is_binary(dimension) do
    (list ++ [dimension])
  end
end
