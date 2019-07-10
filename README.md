[![Build Status](https://travis-ci.org/koleksiuk/ga_api_client_ex.svg?branch=master)](https://travis-ci.org/koleksiuk/ga_api_client_ex)

# GaApiClient

Google Analytics Core Reporting V4 API Client for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ga_api_client` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:ga_api_client, "~> 0.1.0"}]
end
```

## Running tests

`mix espec`

## Building simple query

iex> report_request = GaApiClient.ReportRequest.build("12345") # view id
iex> report_requests = GaApiClient.ReportRequests.build(report_request)
iex> profile = %GaApiClient.Profile{ access_token: "foobar" }
iex> GaApiClient.Connection.client(profile) |> GaApiClient.Connection.get_batch(report_requests)

## Docs

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ga_api_client](https://hexdocs.pm/ga_api_client).
