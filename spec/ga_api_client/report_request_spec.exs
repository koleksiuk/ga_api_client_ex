defmodule GaApiClient.ReportRequestSpec do
  use ESpec

  alias GaApiClient.ReportRequest

  let :view_id, do: "1234"

  let :report_request do
    described_module().build(view_id())
  end

  it "is possible to merge metrics and dimensions" do
    report =
      report_request()
      |> ReportRequest.dimensions([:city, :country])
      |> ReportRequest.metrics([:pageviews])

    expect report |> to(eq %GaApiClient.ReportRequest {
      view_id: view_id(),
      dimensions: [:city, :country],
      metrics: [:pageviews]
    })
  end

  describe "dimensions/2" do
    describe "argument is an atom" do
      let :dimension do
        :country
      end

      it "adds a dimension to the report" do
        report =
          report_request()
          |> described_module().dimensions(dimension())

        expect report |> to(eq %GaApiClient.ReportRequest {
          view_id: "1234",
          dimensions: [dimension()],
          metrics: []
        })
      end

      it "allows duplicates" do
        report =
          report_request()
          |> described_module().dimensions(dimension())
          |> described_module().dimensions(dimension())

        expect report |> to(eq %GaApiClient.ReportRequest {
          view_id: "1234",
          dimensions: [dimension(), dimension()],
          metrics: []
        })
      end
    end

    describe "argument is a list of dimensions (atoms)" do
      let :dimension do
        [:country, :city]
      end

      it "adds all dimension to the report" do
        report =
          report_request()
          |> described_module().dimensions(dimension())

        expect report |> to(eq %GaApiClient.ReportRequest {
          view_id: "1234",
          dimensions: dimension(),
          metrics: []
        })
      end

      it "supports chaining" do
        report =
          report_request()
          |> described_module().dimensions(dimension())
          |> described_module().dimensions(:region)

        expect report |> to(eq %GaApiClient.ReportRequest {
          view_id: "1234",
          dimensions: dimension() ++ [:region],
          metrics: []
        })
      end

      it "allows duplicates" do
        report =
          report_request()
          |> described_module().dimensions(dimension())
          |> described_module().dimensions(dimension())

        expect report |> to(eq %GaApiClient.ReportRequest {
          view_id: "1234",
          dimensions: dimension() ++ dimension(),
          metrics: []
        })
      end
    end
  end
end
