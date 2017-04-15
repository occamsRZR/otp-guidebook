defmodule Metex.Worker do

  def loop do
    receive do
      {sender_pid, location} ->
        send(sender_pid, {:ok, temperature_of(location)})
      _ ->
        IO.puts "don't know how to process this message"
    end
    loop
  end

  defp temperature_of(location) do
    result = location |> url_for |> HTTPoison.get |> parse_response
    case result do
      {:ok, temp} ->
        "#{location}: #{temp}°F"
      :error ->
        "#{location} not found"
    end
  end

  defp url_for(location) do
    location = URI.encode(location)
    "http://api.openweathermap.org/data/2.5/weather?q=#{location}&appid=#{apikey}"
  end

  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body |> JSON.decode! |> compute_temperature
  end

  defp parse_response(_) do
    :error
  end

  defp compute_temperature(json) do
    try do
      temp = (json["main"]["temp"] - 273.15) |> convert_to_fahrenheit |> Float.round(1)
      {:ok, temp}
    rescue
      _ -> :error
    end
  end

  defp convert_to_fahrenheit(temperature) do
    (temperature * 9/5) + 32
  end

  defp apikey do
    "4e38451c8d48c8ada83b91318b6a2b97"
  end
end
