defmodule Chopstick do

  def start do
    sitck = spawn_link(fn -> available() end)
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit -> :ok
    end
  end


  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  # A philosopher requests stick
  def request(stick, ms) do
    send(stick, {:request, self()})
    receive do
      :granted -> :ok
    after
      ms -> :no
    end
  end

  # Return stick
  def return(stick) do
    send(stick, :return)
  end

  def quit(stick) do
    send(stick, :quti)
  end

end
