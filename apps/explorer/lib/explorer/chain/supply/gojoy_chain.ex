defmodule Explorer.Chain.Supply.GojoyChain do
  @moduledoc """
  Defines the supply API for calculating supply for Gojoy Chain.
  """
  use Explorer.Chain.Supply

  import Explorer.Chain, only: [
    string_to_address_hash: 1,
    hashes_to_addresses: 1
  ]

  alias Explorer.Chain.Wei

  @total_supply 1_000_000_000
  @master_address "0xd0B9f1f7742429A0768f561aeaBEc4a752578167"

  @spec circulating :: non_neg_integer()
  def circulating do
    with {:ok, address_hash} <- string_to_address_hash(@master_address) do
      addresses = hashes_to_addresses([address_hash])
      address = List.first(addresses)
      if address.fetched_coin_balance do
        @total_supply
        |> Decimal.new()
        |> Wei.from(:ether)
        |> Wei.sub(address.fetched_coin_balance)
        |> Wei.to(:ether)
        |> Decimal.round()
        |> Decimal.to_integer()
      else
        0
      end
    else
      _ -> 0
    end
  end

  @spec total :: non_neg_integer()
  def total do
    @total_supply
  end
end
