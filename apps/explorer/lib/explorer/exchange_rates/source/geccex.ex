defmodule Explorer.ExchangeRates.Source.GECCEX do
  @moduledoc """
  Adapter for fetching exchange rates from https://interface.geccex.com.
  """

  alias Explorer.ExchangeRates.{Source, Token}

  import Source, only: [decode_json: 1, to_decimal: 1]

  @behaviour Source

  @impl Source
  def format_data(data) do
    for item <- decode_json(data), not is_nil(item["last_updated"]) do
      data_obj = item["data"]


      {last_updated_as_unix, _} = Integer.parse(item["last_updated"])
      last_updated = DateTime.from_unix!(last_updated_as_unix)

      %Token{
        available_supply: to_decimal(0),
        btc_value: to_decimal(0),
        id: item["id"],
        last_updated: last_updated,
        market_cap_usd: to_decimal(0),
        name: item["name"],
        symbol: item["symbol"],
        usd_value: to_decimal(data_obj["usd"]),
        volume_24h_usd: to_decimal(0)
      }
    end
  end

  @impl Source
  def source_url do
    app_id = Application.get_env(:explorer, Explorer.ExchangeRates, :app_id)
    code = Application.get_env(:explorer, Explorer.ExchangeRates, :code)
    "#{base_url()}/transfer/price?app_id=#{app_id}&code=#{code}"
  end

  defp base_url do
    config(:base_url) || "https://interface.geccex.com"
  end

  @spec config(atom()) :: term
  defp config(key) do
    Application.get_env(:explorer, __MODULE__, [])[key]
  end
end
