defmodule Pingpong do
  def start do
    ping_pid = spawn(Pingpong.Ping, :loop, [])
    pong_pid = spawn(Pingpong.Pong, :loop, [])
    send(ping_pid, {pong_pid, "pong"})
    {:ok, ping_pid, pong_pid}
  end

  def stop(ping_pid, pong_pid) do
    send(ping_pid, {ping_pid, "stop"})
    send(pong_pid, {pong_pid, "stop"})
  end
  
  defmodule Ping do

    def loop do
      receive do
        {pid, "pong"} ->
          IO.puts "Sending ping!"
          :timer.sleep(5000);
          send(pid, {self, "ping"})
          loop
        {_, "stop"} ->
          IO.puts "stopping"
        _ ->
          loop
      end

    end
  end

  defmodule Pong do
    def loop do
      receive do
        {pid, "ping"} ->
          IO.puts "Sending pong!"
          :timer.sleep(5000);
          send(pid, {self, "pong"})
          loop
        {_, "stop"} ->
          IO.puts "stopping"
        _ ->
          loop
      end
    end
  end
end
