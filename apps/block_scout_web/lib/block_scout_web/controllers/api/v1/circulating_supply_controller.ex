defmodule BlockScoutWeb.API.V1.CirculatingSupplyController do
  use BlockScoutWeb, :controller

  alias Explorer.Chain
  alias Explorer.Chain.Wei

  def circulating_supply(conn, _) do
    circulating = Chain.circulating_supply()
      |> Decimal.new()
      |> Wei.from(:ether)
      |> Wei.to(:wei)
      |> Decimal.to_string()

    render(conn, :circulatingsupply, circulating: circulating)
  end
end
