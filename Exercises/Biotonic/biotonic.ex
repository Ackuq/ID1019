defmodule Biotonic do

  def comp(low, high) do spawn(fn() -> comp(0, low, high) end) end

  def comp(n, low, high) do
    receive do
      {:epoch, ^n, x1} ->
        receive do
          {:epoch, ^n, x2} ->
            if x1 < x2 do
              send(low, {:epoch, n, x1})
              send(high, {:epoch, n, x2})
            else
              send(low, {:epoch, n, x2})
              send(low, {:epoch, n, x1})
            end
            comp(n+1, low, high)
        end
      {:done, n} ->
        send(low, {:done, n})
        send(high, {:done, n})
    end
  end

  def setup(sinks) do
    n = length(sinks)
    setup(n, sinks)
  end

  def setup(2, [s1, s2]) do
    cmp = comp(s1, s2)
    [cmp, cmp]
  end

  def merge(2, [s1, s2]) do
    cmp1 = comp(s1,s2)
    [cmp1, cmp1]
  end

end
