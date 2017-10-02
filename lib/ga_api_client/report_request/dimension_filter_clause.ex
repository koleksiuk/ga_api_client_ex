defmodule GaApiClient.ReportRequest.DimensionFilterClause do
  alias GaApiClient.ReportRequest.DimensionFilter

  defstruct filters: [], operator: :or

  def merge(list, operator, filters_list) when is_atom(operator) and is_list(filters_list) do
    filters = filters_list
              |> Enum.reduce([], fn (filter_tuple, acc) -> add_filters(acc, filter_tuple) end)

    list ++ [%__MODULE__{ filters: filters, operator: operator }]
  end

  defp add_filters(list, {dimension, filter, value, negate}) do
    DimensionFilter.merge(list, dimension, filter, value, negate)
  end
end
