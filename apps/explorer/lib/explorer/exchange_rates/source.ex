defmodule Explorer.ExchangeRates.Source do
  @moduledoc """
  Behaviour for fetching exchange rates from external sources.
  """

  alias Explorer.ExchangeRates.Source.{CoinMarketCap, CoinGecko, GECCEX}
  alias Explorer.ExchangeRates.Token
  alias HTTPoison.{Error, Response}

  @doc """
  Fetches exchange rates for currencies/tokens.
  """
  @spec fetch_exchange_rates(module) :: {:ok, [Token.t()]} | {:error, any}
  def fetch_exchange_rates(source \\ exchange_rates_source()) do
    case source do
      CoinMarketCap ->
        fetch_exchange_rates_from_paginable_source(source)

      CoinGecko ->
        fetch_exchange_rates_request(source)

      GECCEX ->
        fetch_exchange_rates_geccex(source)
    end
  end

  defp fetch_exchange_rates_geccex(source) do
    case HTTPoison.post(source.source_url(), source.body(), headers()) do
      {:ok, %Response{body: body, status_code: 200}} ->
        {:ok, source.format_data(body)}

      {:ok, %Response{body: _, status_code: 500}} ->
        {:error, "Error querying GECCEX"}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp fetch_exchange_rates_from_paginable_source(source, page \\ 1) do
    case HTTPoison.get(source.source_url(page), headers()) do
      {:ok, %Response{body: body, status_code: 200}} ->
        cond do
          body =~ Explorer.coin() -> {:ok, source.format_data(body)}
          page == source.max_page_number -> {:error, "exchange rates not found for this network"}
          true -> fetch_exchange_rates_from_paginable_source(source, page + 1)
        end

      {:ok, %Response{body: body, status_code: status_code}} when status_code in 400..499 ->
        {:error, decode_json(body)["error"]}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp fetch_exchange_rates_request(source) do
    case HTTPoison.get(source.source_url(), headers()) do
      {:ok, %Response{body: body, status_code: 200}} ->
        {:ok, source.format_data(body)}

      {:ok, %Response{body: body, status_code: status_code}} when status_code in 400..499 ->
        {:error, decode_json(body)["error"]}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Callback for api's to format the data returned by their query.
  """
  @callback format_data(String.t()) :: [any]

  @doc """
  Url for the api to query to get the market info.
  """
  @callback source_url :: String.t()

  def headers do
    [{"Content-Type", "application/json"}]
  end

  def decode_json(data) do
    Jason.decode!(data)
  end

  def to_decimal(nil), do: nil

  def to_decimal(%Decimal{} = value), do: value

  def to_decimal(value) when is_float(value) do
    Decimal.from_float(value)
  end

  def to_decimal(value) when is_integer(value) or is_binary(value) do
    Decimal.new(value)
  end

  @spec exchange_rates_source() :: module()
  defp exchange_rates_source do
    config(:source) || Explorer.ExchangeRates.Source.GECCEX
  end

  @spec config(atom()) :: term
  defp config(key) do
    Application.get_env(:explorer, __MODULE__, [])[key]
  end
end
