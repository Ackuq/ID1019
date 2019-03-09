defmodule Fib do

  def fib() do
    fn() -> cont(0,1) end
  end

  def cont(prev, curr) do
    {:ok, curr, fn() -> cont(curr, curr + prev) end}
  end

end
