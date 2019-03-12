defmodule Explorer.ExchangeRates.Source.GECCEX do
  @moduledoc """
  Adapter for fetching exchange rates from https://interface.geccex.com.
  """

  alias Explorer.ExchangeRates.{Source, Token}

  import Source, only: [decode_json: 1, to_decimal: 1]

  @behaviour Source

  @impl Source
  def format_data(data) do
    json = decode_json(data)
    if Map.has_key?(json, "data") do
      data_obj = json["data"]

      if Map.has_key?(data_obj, "usd") do
        [%Token{
            available_supply: to_decimal(0),
            btc_value: to_decimal(0),
            id: "ghu",
            last_updated: DateTime.utc_now(),
            market_cap_usd: to_decimal(0),
            name: "GHU",
            symbol: "GHU",
            usd_value: to_decimal(data_obj["usd"]),
            volume_24h_usd: to_decimal(0)
          }
        ]
      end
    end
  end

  @impl Source
  def source_url do
    app_id = config(:app_id)
    code = config(:code)
    "#{base_url()}/transfer/price?appId=#{app_id}&code=#{code}"
  end

  @spec body() :: String.t()
  def body do
    # GHU: Hardcoded GEC token symbol since pulling from GECCEX API.
    Jason.encode!(%{
      currency: "GEC"
    })
  end

  defp base_url do
    config(:base_url) || "https://interface.geccex.com"
  end

  @spec config(atom()) :: term
  defp config(key) do
    Application.get_env(:explorer, __MODULE__, [])[key]
  end
end
