defmodule Queue do

    # Create new queue
    def new() do {:queue, [], []} end

    def add({:queue, back, front}, element) do
      {:queue, [element|back], front}
    end

    def remove({:queue, [], []}) do :fail
    def remove({:queue, back, []}) do
      remove({:queue, [], Enum.reverse(back)})
    end
    def remove({:queue, back, [head|tail]}) do
      {:ok, head, {:queue, back, tail}}
    end
end
