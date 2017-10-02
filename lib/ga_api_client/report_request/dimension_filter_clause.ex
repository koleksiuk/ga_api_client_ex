defmodule GaApiClient.ReportRequest.DimensionFilterClause do
  alias GaApiClient.ReportRequest.DimensionFilter

  defstruct filters: []

  def merge(list, filters_list) when is_list(filters_list) do
    filters = filters_list
              |> Enum.reduce([], fn (filter_tuple, acc) -> merge(acc, filter_tuple) end)

    [%__MODULE__{ filters: filters } | list]
  end

  def merge(list, {dimension, filter, value, negate}) do
    DimensionFilter.merge(list, dimension, filter, value, negate)
  end
end
