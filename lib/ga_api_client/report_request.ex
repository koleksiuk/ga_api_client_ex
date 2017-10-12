defmodule GaApiClient.ReportRequest do
  @default_page_size 10_000

  defstruct view_id: nil, date_ranges: [], dimensions: [], metrics: [],
            metric_filters: [], dimension_filter_clauses: [], page_token: nil,
            page_size: @default_page_size, include_empty: false,
            hide_totals: false, hide_value_ranges: false

  alias GaApiClient.ReportRequest.{DateRange, Dimension, DimensionFilterClause,
                                   Metric}

  @doc ~S"""
    Returns ReportRequest struct with view_id

    iex> GaApiClient.ReportRequest.build("1234")
    %GaApiClient.ReportRequest { view_id: "1234" }
  """
  def build(view_id) do
    %__MODULE__{ view_id: view_id }
  end

  def date_range(report, start_date, end_date) do
    %{ report | date_ranges: DateRange.merge(report.date_ranges, {start_date, end_date}) }
  end

  @doc ~S"""
    Adds dimension to report

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.dimensions(:country)
    %GaApiClient.ReportRequest { dimensions: [:country] }

    iex> %GaApiClient.ReportRequest { dimensions: [:region] } |> GaApiClient.ReportRequest.dimensions(:country)
    %GaApiClient.ReportRequest { dimensions: [:region, :country] }

    iex> %GaApiClient.ReportRequest { dimensions: [:region] } |> GaApiClient.ReportRequest.dimensions(:region)
    %GaApiClient.ReportRequest { dimensions: [:region, :region] }

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.dimensions([:country, :city])
    %GaApiClient.ReportRequest {
      dimensions: [:country, :city]
    }

    iex> %GaApiClient.ReportRequest { dimensions: [:city] } |> GaApiClient.ReportRequest.dimensions([:country, :city])
    %GaApiClient.ReportRequest {
      dimensions: [:city, :country, :city]
    }

    iex> %GaApiClient.ReportRequest { dimensions: [:city] } |> GaApiClient.ReportRequest.dimensions([:country, :network_location])
    %GaApiClient.ReportRequest {
      dimensions: [:city, :country, :network_location]
    }
  """
  def dimensions(report, dimension) when is_atom(dimension) do
    %{report | dimensions: Dimension.merge(report.dimensions, dimension)}
  end

  def dimensions(report, dimensions) when is_list(dimensions) do
    Enum.reduce(dimensions, report, fn(dimension, report) ->
      dimensions(report, dimension)
    end)
  end

  @doc ~S"""
    Adds metric to report

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.metrics(:pageviews)
    %GaApiClient.ReportRequest { metrics: [:pageviews] }

    iex> %GaApiClient.ReportRequest { metrics: [:sessions] } |> GaApiClient.ReportRequest.metrics(:pageviews)
    %GaApiClient.ReportRequest { metrics: [:sessions, :pageviews] }

    iex> %GaApiClient.ReportRequest { metrics: [:sessions] } |> GaApiClient.ReportRequest.metrics(:sessions)
    %GaApiClient.ReportRequest { metrics: [:sessions, :sessions] }

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.metrics([:pageviews, :sessions])
    %GaApiClient.ReportRequest {
      metrics: [:pageviews, :sessions]
    }

    iex> %GaApiClient.ReportRequest { metrics: [:sessions] } |> GaApiClient.ReportRequest.metrics([:pageviews, :sessions])
    %GaApiClient.ReportRequest {
      metrics: [:sessions, :pageviews, :sessions]
    }

    iex> %GaApiClient.ReportRequest { metrics: [:sessions] } |> GaApiClient.ReportRequest.metrics([:pageviews, :users])
    %GaApiClient.ReportRequest {
      metrics: [:sessions, :pageviews, :users]
    }
  """
  def metrics(report, metric) when is_atom(metric) do
    %{report | metrics: Metric.merge(report.metrics, metric)}
  end

  def metrics(report, metrics) when is_list(metrics) do
    Enum.reduce(metrics, report, fn(metric, report) ->
      metrics(report, metric)
    end)
  end

  @doc ~S"""
  Adds dimension filters to report

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.dimension_filter_clauses(:and, [{:country, :equal, "Finland", false}])
    %GaApiClient.ReportRequest {
      dimension_filter_clauses: [
        %GaApiClient.ReportRequest.DimensionFilterClause {
          operator: :and,
          filters: [
            %GaApiClient.ReportRequest.DimensionFilter{dimension: :country, filter: "EXACT", negate: false, value: "Finland"}
          ]
        }
      ]
    }

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.dimension_filter_clauses(:and, {:country, :equal, "Finland", false})
    %GaApiClient.ReportRequest {
      dimension_filter_clauses: [
        %GaApiClient.ReportRequest.DimensionFilterClause {
          operator: :and,
          filters: [
            %GaApiClient.ReportRequest.DimensionFilter{dimension: :country, filter: "EXACT", negate: false, value: "Finland"}
          ]
        }
      ]
    }


    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.dimension_filter_clauses(:and, {:country, :equal, "Finland", false}) |> GaApiClient.ReportRequest.dimension_filter_clauses([{:country, :equal, "Sweden", false}, {:city, :regex, "Stock", true}])
    %GaApiClient.ReportRequest {
      dimension_filter_clauses: [
        %GaApiClient.ReportRequest.DimensionFilterClause {
          operator: :and,
          filters: [
            %GaApiClient.ReportRequest.DimensionFilter{dimension: :country, filter: "EXACT", negate: false, value: "Finland"}
          ]
        },
        %GaApiClient.ReportRequest.DimensionFilterClause {
          operator: :or,
          filters: [
            %GaApiClient.ReportRequest.DimensionFilter{dimension: :country, filter: "EXACT", negate: false, value: "Sweden"},
            %GaApiClient.ReportRequest.DimensionFilter{dimension: :city, filter: "REGEXP", negate: true, value: "Stock"}
          ]
        }
      ]
    }
  """

  def dimension_filter_clauses(report, operator \\ :or, filters_clause)
  def dimension_filter_clauses(report, operator, filters_clause) when is_list(filters_clause) do
    %{ report |
       dimension_filter_clauses: DimensionFilterClause.merge(
         report.dimension_filter_clauses, operator, filters_clause
       )
    }
  end

  def dimension_filter_clauses(report, operator, filter) do
    dimension_filter_clauses(report, operator, [filter])
  end
end
