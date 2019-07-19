defmodule Explorer.Chain.Supply.GojoyChain do
  @moduledoc """
  Defines the supply API for calculating supply for Gojoy Chain.
  """
  use Explorer.Chain.Supply

  import Explorer.Chain, only: [
    string_to_address_hash: 1,
    hashes_to_addresses: 1
  ]

  @total_supply 1_000_000_000
  @master_address "0xd0B9f1f7742429A0768f561aeaBEc4a752578167"

  @spec circulating :: non_neg_integer()
  def circulating do
    with {:ok, address_hash} <- string_to_address_hash(@master_address) do
      addresses = hashes_to_addresses([address_hash])
      address = List.first(addresses)
      IO.inspect address
      if address.fetched_coin_balance && address.fetched_coin_balance.value do
        @total_supply - address.fetched_coin_balance.value
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
