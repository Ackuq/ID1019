defmodule Heap do

  @type heap() :: {:heap, integer(), heap(), heap()} | nil

  @spec new() :: heap()
  def new() do
    nil
  end

  @spec add(heap(), integer()) :: heap()
  def add(nil, n) do {:heap, n, nil, nil} end
  def add({:heap, v, left, right}, n) do
    if n < v do
      {:heap, v, add(right, n), left}
    else
      {:heap, n, add(right, v), left}
    end
  end

  @spec pop(heap()) :: :fail | {:ok, integer(), heap()}
  def pop(nil) do :fail end
  def pop({:heap, v, left, nil}) do
    {:ok, v, left}
  end
  def pop({:heap, v, nil, right}) do
    {:ok, v, right}
  end
  def pop({:heap, v, {:heap, l, _, _}=left,{:heap, r, _, _}=right}) do
    if l > r do
      {:ok, high, rest} = pop(left)
      {:ok, v, {:heap, high, rest, right}}
    else
      {:ok, high, rest} = pop(right)
      {:ok, v, {:heap, high, left, rest}}
    end
  end

  @spec swap(heap(), integer()) :: {:ok, integer(), heap()}
  def swap(nil, n) do {:ok, n, nil} end
  def swap({:heap, v, left, right}, n) do
    if n < v do
      {:ok, n, left} = swap(left, n)
      {:ok, n, right} = swap(right, n)
      {:ok, v, {:heap, n, left, right}}
    else
      {:ok, n, {:heap, v, left, right}}
    end
  end
end
