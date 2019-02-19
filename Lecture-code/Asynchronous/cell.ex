defmodule Cell do

  def start(val) do
    {:cell, spawn_link(fn() -> init(val) end)}
  end

  def cell(v) do
    receive do
      {:read, ref, pid} ->
        send(pid, {:value, ref, v})
        cell(v)
      {:write, w, ref, pid} ->
        send(pid, {:ok, ref})
        cell(w)
      :quit ->
        :ok
    end
  end

  def read({:cell, cell}) do
    send(cell, {:read, self()})
    receive do
      {:value, v} ->
        v
    end
  end

  def write({:cell, cell}, val) do
    send(cell, {:write, val, self()})
    receive do
      :ok ->
        :ok
    end
  end

  def quit({:cell, cell}) do
    send(cell, :quit)
  end

  def init(val) do
    cell(val)
  end

end
