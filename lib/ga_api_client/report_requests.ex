defmodule GaApiClient.ReportRequests do
  @derive Jason.Encoder

  defstruct report_requests: []

  def build() do
    %__MODULE__{}
  end

  def build(report_requests) when is_list(report_requests) do
    %__MODULE__{report_requests: report_requests}
  end

  def build(report_request) do
    %__MODULE__{report_requests: [report_request]}
  end
end
