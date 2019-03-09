defmodule Test do

  def bench(host, port, requests) do
    start = Time.utc_now()
    run(requests, host, port)
    finish = Time.utc_now()
    diff = Time.diff(finish, start, :millisecond)
    IO.puts("Benchmark: #{requests} requests in #{diff} ms")
  end

  defp run(0, _host, _port), do: :ok
  defp run(n, host, port) do
    request(host, port)
    run(n-1, host, port)
  end

  defp request(host, port) do
    opt = [:list, active: false, reuseaddr: true]
    {:ok, server} = :gen_tcp.connect(host, port, opt)
    :gen_tcp.send(server, HTTP.get("/foo.html"))
    {:ok, _reply} = :gen_tcp.recv(server, 0)
    :gen_tcp.close(server)
  end


end
