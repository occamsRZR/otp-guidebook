defmodule Twittertoy do
  def start_stream(user) do
    pid = spawn(fn ->
      stream = ExTwitter.stream_filter(follow: user)
      for tweet <- stream do
        IO.puts inspect( tweet.user )
        #print_tweet(tweet.text)
      end
    end)
    pid
  end

  def print_tweet("RT" <> _), do: {:retweet}
  def print_tweet(tweet_text) do
    IO.puts tweet_text
  end
  
  def stop_stream(pid) do
    ExTwitter.stream_control(pid, :stop)
  end
end
