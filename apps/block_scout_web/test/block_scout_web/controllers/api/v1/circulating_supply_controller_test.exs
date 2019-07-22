defmodule BlockScoutWeb.API.V1.CirculatingSupplyControllerTest do
  use BlockScoutWeb.ConnCase

  alias Explorer.Chain

  test "circulatingsupply", %{conn: conn} do
    request = get(conn, api_v1_circulatingsupply_path(conn, :circulating_supply))
    assert response = json_response(request, 200)

    expected = Chain.circulating_supply()
      |> Decimal.new()
      |> Wei.from(:ether)
      |> Wei.to(:wei)
      |> Decimal.to_string()
    assert response == expected
  end
end
