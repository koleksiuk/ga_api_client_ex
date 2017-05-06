defmodule GaApiClient.ReportRequest do
  @default_page_size 10_000

  defstruct view_id: nil, date_ranges: [], dimensions: [], metrics: [],
            metric_filters: [], dimension_filters: [], page_token: nil,
            page_size: @default_page_size, include_empty: false,
            hide_totals: false, hide_value_ranges: false

  alias GaApiClient.ReportRequest.Dimension
  alias GaApiClient.ReportRequest.Metric

  @doc ~S"""
    Returns ReportRequest struct with view_id

    iex> GaApiClient.ReportRequest.build("1234")
    %GaApiClient.ReportRequest { view_id: "1234" }
  """
  def build(view_id) do
    %__MODULE__{ view_id: view_id }
  end

  @doc ~S"""
    Adds dimension to report

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.dimensions(:country)
    %GaApiClient.ReportRequest { dimensions: [:country] }

    iex> %GaApiClient.ReportRequest { dimensions: [:region] } |> GaApiClient.ReportRequest.dimensions(:country)
    %GaApiClient.ReportRequest { dimensions: [:region, :country] }

    iex> %GaApiClient.ReportRequest { dimensions: [:region] } |> GaApiClient.ReportRequest.dimensions(:region)
    %GaApiClient.ReportRequest { dimensions: [:region] }

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.dimensions([:country, :city])
    %GaApiClient.ReportRequest {
      dimensions: [:country, :city]
    }

    iex> %GaApiClient.ReportRequest { dimensions: [:city] } |> GaApiClient.ReportRequest.dimensions([:country, :city])
    %GaApiClient.ReportRequest {
      dimensions: [:city, :country]
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
    %GaApiClient.ReportRequest { metrics: [:sessions] }

    iex> %GaApiClient.ReportRequest {} |> GaApiClient.ReportRequest.metrics([:pageviews, :sessions])
    %GaApiClient.ReportRequest {
      metrics: [:pageviews, :sessions]
    }

    iex> %GaApiClient.ReportRequest { metrics: [:sessions] } |> GaApiClient.ReportRequest.metrics([:pageviews, :sessions])
    %GaApiClient.ReportRequest {
      metrics: [:sessions, :pageviews]
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
end
