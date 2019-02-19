defmodule Redrum do

  def redrum({:cell, cell}) do
    ref = make_ref()
    send(cell, {:read, ref, self()})
    ref
  end

  def murder(ref) do
    receive do
      {:value, ^ref, value} ->
        value
    end
  end

end
