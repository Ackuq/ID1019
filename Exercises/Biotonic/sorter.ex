defmodule Sorter do

  def sorter(sinks) do
    spawn(fn() -> init(sinks) end)
  end

  def init(sinks) do
    netw = Biotonic.setup(sinks)
    sorter(0, netw)
  end

  def sorter(n, netw) do
    receive do
      {:sort, epoch} ->
        each(zip(netw, this),
          fn({cmp, x}) -> send(cmp,{:epoc, n, x}) end)
        sorter(n+1, netw)
      :done ->
        each(netw, fn(cmp) -> send(cmp, {:done, n}) end)
    end
  end
end
