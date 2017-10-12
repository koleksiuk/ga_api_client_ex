defmodule GaApiClient.ReportRequest.DateRange do
  defstruct start_date: nil, end_date: nil

  @doc ~S"""
    Adds date range to a list

    iex> GaApiClient.ReportRequest.DateRange.merge([], {~D[2017-01-01], ~D[2017-01-02]})
    [%GaApiClient.ReportRequest.DateRange{ start_date: ~D[2017-01-01], end_date: ~D[2017-01-02] }]
  """

  def merge(list, {start_date, end_date}) do
    list ++ [build_date_range(start_date, end_date)]
  end

  defp build_date_range(start_date, end_date) do
    %__MODULE__{
      start_date: convert_date(start_date),
      end_date: convert_date(end_date)
    }
  end

  defp convert_date(date) when is_tuple(date) do
    {:ok, parsed_date} = Date.from_erl(date)
    parsed_date
  end

  defp convert_date(date) when is_map(date) do
    case Map.fetch(date, :__struct__) do
      {:ok, Date} -> date
      :error -> raise "expect #{inspect(date)} to be a Date struct"
    end
  end
end
