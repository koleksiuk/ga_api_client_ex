defmodule GaApiClient.ReportRequest.Metric do
  def merge(list, metric) when is_atom(metric) or is_binary(metric) do
    (list ++ [metric]) |> Enum.uniq
  end
end
