defmodule GaApiClient.ReportRequest.Dimension do
  def merge(list, dimension) when is_atom(dimension) or is_binary(dimension) do
    (list ++ [dimension]) |> Enum.uniq
  end
end
