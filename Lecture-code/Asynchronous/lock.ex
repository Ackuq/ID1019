defmodule Lock do

  def start() do
    {:lock, spawn_link(fn() -> free() end)}
  end

  def free() do
    receive do
      {:take, pid} ->
        ref = make_ref()
        self(pid, ref, :taken)
        taken(ref)
    end
  end

  def taken(ref) do
    receive do
      {:release, ^ref} ->
        free()
    end
  end
end
