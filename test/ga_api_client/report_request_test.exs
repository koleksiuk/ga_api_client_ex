defmodule GaApiClient.ReportRequestTest do
  use ExUnit.Case
  doctest GaApiClient.ReportRequest

  alias GaApiClient.ReportRequest

  test "it is possible to merge metrics and dimensions" do
    report_request = ReportRequest.build("1234")
                   |> ReportRequest.dimensions([:city, :country])
                   |> ReportRequest.metrics([:pageviews])

    assert report_request == %GaApiClient.ReportRequest {
      view_id: "1234",
      dimensions: [:city, :country],
      metrics: [:pageviews]
    }

  end
end
