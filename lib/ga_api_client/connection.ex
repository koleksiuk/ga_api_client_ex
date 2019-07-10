defmodule GaApiClient.Connection do
  use Tesla

  def get_batch(client, report_requests) do
    Tesla.post(client, "/v4/reports:batchGet", report_requests)
  end

  def client(%{ access_token: access_token }) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://analyticsreporting.googleapis.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Query, [access_token: access_token]}
    ]

    Tesla.client(middleware)
  end
end
