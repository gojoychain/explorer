defmodule BlockScoutWeb.API.V1.CirculatingSupplyController do
  use BlockScoutWeb, :controller

  alias Explorer.Chain

  def supply(conn, _) do
    circulating = Chain.circulating_supply()

    render(conn, :supply, circulating: circulating)
  end
end
