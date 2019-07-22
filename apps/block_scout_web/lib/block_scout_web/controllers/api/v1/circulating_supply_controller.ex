defmodule BlockScoutWeb.API.V1.CirculatingSupplyController do
  use BlockScoutWeb, :controller

  alias Explorer.Chain

  def circulating_supply(conn, _) do
    circulating = Chain.circulating_supply()

    render(conn, :circulatingsupply, circulating: circulating)
  end
end
