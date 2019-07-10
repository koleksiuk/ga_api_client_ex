defmodule GaApiClient.ReportRequest.DimensionFilter do
  @derive Jason.Encoder
  defstruct dimension: nil, filter: nil, value: nil, negate: false

  def merge(list, dimension, filter, value, negate) do
    (list ++ [build_filter(dimension, filter, value, negate)])
  end

  defp build_filter(dimension, filter, value, negate) when (is_atom(dimension) or is_binary(dimension))
                                                           and (is_atom(filter) or is_binary(filter))
                                                           and is_binary(value) and is_boolean(negate) do
    %__MODULE__{
      dimension: dimension,
      filter: transform_operator(filter),
      value: value,
      negate: negate
    }
  end

  defp transform_operator(operator) when is_atom(operator) do
    # missing: NUMERIC_EQUAL, NUMERIC_GREATER_THAN, NUMERIC_LESS_THAN
    case operator do
      :exact -> "EXACT"
      :equal -> "EXACT"
      :regexp -> "REGEXP"
      :begins -> "BEGINS_WITH"
      :ends -> "ENDS_WITH"
      :partial -> "PARTIAL"
      :in_list -> "IN_LIST"
      _ -> "REGEXP"
    end
  end

  defp transform_operator(operator) when is_binary(operator), do: operator
end
