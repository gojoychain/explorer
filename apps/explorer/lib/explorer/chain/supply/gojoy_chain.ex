defmodule Explorer.Chain.Supply.GojoyChain do
  @moduledoc """
  Defines the supply API for calculating supply for Gojoy Chain.
  """
  use Explorer.Chain.Supply

  @total_supply 1_000_000_000

  @spec circulating :: non_neg_integer()
  def circulating do
    @total_supply
  end

  @spec total :: non_neg_integer()
  def total do
    @total_supply
  end
end
