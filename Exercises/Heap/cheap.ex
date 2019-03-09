defmodule Cheap do

  @type heap() :: {:heap, integer(), heap(), heap()} | nil
  @type cmp() :: (any(), any() -> bool())

  @spec add(heap(), any(), cmp()) :: heap()
  def add(nil, n, _ ) do {:heap, n, nil, nil} end
  def add({:heap, v, left, right}, n, cmp) do
    if cmp.(n, v) do
      {:heap, v, add(right, n, cmp), left}
    else
      {:heap, n, add(right, v, cmp), left}
    end
  end

  @type cheap() :: {:cheap, heap(), cmp()}

  @spec new(cmp()) :: cheap()
  def new(cmp) do {:cheap, nil, cmp} end

  @spec add(cheap(), any()) :: cheap()
  def add({:cheap, heap, cmp}, v) do
    {:cheap, add(heap, v, cmp), cmp}
  end
end
