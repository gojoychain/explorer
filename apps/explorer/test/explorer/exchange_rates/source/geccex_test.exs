defmodule Explorer.ExchangeRates.Source.GECCEXTest do
  use ExUnit.Case

  alias Explorer.ExchangeRates.Token
  alias Explorer.ExchangeRates.Source.GECCEX

  @json """
  {
    "code": 0,
    "msg": [
        ""
    ],
    "data": {
        "usd": 3.026378,
        "percent": 0.0029375174398528006
    }
  }
  """

  describe "format_data/1" do
    test "returns valid tokens with valid data" do
      # Need to format_data first to get the generated last_updated
      formatted = GECCEX.format_data(@json)

      expected = [
        %Token{
          available_supply: Decimal.new("0"),
          btc_value: Decimal.new("0"),
          id: "joy",
          last_updated: Map.get(List.first(formatted), :last_updated),
          market_cap_usd: Decimal.new("0"),
          name: "JOY",
          symbol: "JOY",
          usd_value: Decimal.new("3.026378"),
          volume_24h_usd: Decimal.new("0")
        }
      ]
      assert expected == formatted
    end

    test "returns nothing when given bad data" do
      bad_data = """
      {
        "code": 10009,
        "msg": [
            "授权信息验证失败"
        ],
        "data": {}
      }
      """
      assert [] = GECCEX.format_data(bad_data)
    end
  end
end
