defmodule GaApiClient.ReportRequest.Metric do
  def merge([], metric) when is_atom(metric) or is_binary(metric) do
    [metric]
  end

  def merge(list, metric) do
    (list ++ [metric]) |> Enum.uniq
  end
end
