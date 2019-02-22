defmodule Test do

  def test_link() do
    sender = spawn(fn() -> sender() end)
    receiver = spawn(fn() -> receiver() end)
    {:ok, ls} = Link.start(sender)
    {:ok, lr} = Link.start(receiver)
    send(ls, {:connect, lr})
    send(lr, {:connect, ls})
    send(sender, {:connect, ls})
    send(receiver, {:connect, lr})
    :ok
  end

  ## Test the hub
  def test_hub() do
    sender = spawn(fn() -> sender() end)
    receiver = spawn(fn() -> receiver() end)

    {:ok, ls} = Link.start(sender)
    {:ok, lr} = Link.start(receiver)

    {:ok, hub} = Hub.start()

    send(hub, {:connect, ls})
    send(hub, {:connect, lr})
    :ok
  end

  ## Test network
  def test_new(n) do
    sender = spawn(fn() -> connect(fn(net) -> sender_netw(n, 2, net) end) end)
    receiver = spawn(fn() -> connect(fn(net) -> receiver_netw(n, 1, net) end) end)
    {:ok, ls} = netw(sender, 1)
    {:ok, lr} = netw(receiver, 2)

    {:ok, hub} = Hub.start()

    send(hub, {:connect, ls})
    send(hub, {:connect, lr})
    :ok
  end

  ## Connect link to application network
  def netw(app, i) do
    {:ok, netw} = Network.start(app, i)
    send(app, {:connect, netw})
    lnk(netw)
  end

  def lnk(app) do
    {:ok, link} = Link.start(app)
    send(app, {:connect, link})
    {:ok, link}
  end
  ## Wait for connection

  def connect(f) do
    receive do
      {:connect, n} ->
        f.(n)
    end
  end

  ## Network sender
  def sender_netw(0, _, _) do :ok end
  def sender_netw(i, t, n) do
    :io.format("sender sending ~w\n", [i])
    send(n, {:send, t, i})
    sender_netw(i-1, t, n)
  end

  ## Network reciever
  def receiver_netw(0, _, _) do :ok end
  def receiver_netw(i, t, n) do
    receive do
      msg ->
      :io.format("receiver received ~w\n", [msg])
      receiver_netw(i-1, t, n)
    end
  end
  ## Sender link
  def sender() do
    receive do
      {:connect, lnk} ->
        :io.format("sender connected to link  ~w  ~n", [lnk])
        :io.format("sending hello~n", [])
        send(lnk, {:send, :hello})
    end
  end

  ## Recieving link
  def receiver() do
    receive do
      {:connect, lnk} ->
        :io.format("sender connected to link  ~w  ~n", [lnk])
        :io.format("sending hello~n", [])
        send(lnk, {:master, self()})
    end
  end
end
