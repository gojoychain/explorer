defmodule BlockScoutWeb.API.V1.CirculatingSupplyView do
  use BlockScoutWeb, :view

  def render("circulatingsupply.json", %{circulating: circulating_supply}) do
    circulating_supply
  end
end
