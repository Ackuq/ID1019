defmodule Philosopher do

  @dream 1000
  @eat 50
  @delay 200
  @ms 200

  def start(hunger, right, left, name, ctrl) do
    philosopher = spawn_link(fn -> createPhilosopher(hunger, right, left, name, ctrl) end)
  end

  def createPhilosopher(hunger, right, left, name, ctrl) do
    dreaming(hunger, right, left, name, ctrl)
  end

  # Dreaming
  def dreaming(0, _, _, name, ctrl) do
    IO.puts("#{name} is done!")
    send(ctrl, :done)
  end
  def dreaming(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is dreaming...")
    sleep(@dream)
    waiting(hunger, right, left, name, ctrl)
  end

  # Waiting for soomething
  def waiting(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is waiting..")
    case Chopstick.request(left, @ms) do
      :ok ->
        case Chopstick.request(right, @ms) do
          :ok ->
            IO.puts("#{name} both sticks got picked!")
            eating(hunger, right, left, name, ctrl)
        end
    end
  end

  # Eating
  def eating(hunger, right, left, name, ctrl) do
    IO.puts("#{name} is eating.")
    sleep(@eat)
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(hunger - 1, right, left, name, ctrl)
  end

  def sleep(0) do :ok end
  def sleep(t) do
    :timer.sleep(:rand.uniform(t))
  end

end
