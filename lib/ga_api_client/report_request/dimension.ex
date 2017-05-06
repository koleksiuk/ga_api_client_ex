defmodule GaApiClient.ReportRequest.Dimension do
  def merge([], dimension) when is_atom(dimension) or is_binary(dimension) do
    [dimension]
  end

  def merge(list, dimension) do
    (list ++ [dimension]) |> Enum.uniq
  end
end
