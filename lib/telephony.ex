defmodule Telephony do
 
  def hello(name) do
    "Hello #{name}"  
  end

  def start() do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))
  end
end
