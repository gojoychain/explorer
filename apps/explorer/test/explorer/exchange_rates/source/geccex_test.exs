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
      expected = [
        %Token{
          available_supply: Decimal.new("0"),
          btc_value: Decimal.new("0"),
          id: "ghu",
          last_updated: DateTime.utc_now(),
          market_cap_usd: Decimal.new("0"),
          name: "GHU",
          symbol: "GHU",
          usd_value: Decimal.new("3.026378"),
          volume_24h_usd: Decimal.new("0")
        }
      ]
      assert expected == GECCEX.format_data(@json)
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
