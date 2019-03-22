defmodule Telephony do
  def hello(name) do
    "Hello #{name}"
  end

  def start() do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))
  end

  def print_all_bills(month, year) do
    Enum.each(Subscriber.find_all_pre_paid(), fn s ->
      subscriber = Prepaid.print_bill(month, year, s.number)
      IO.puts("Prepaid Bill Subscriber: #{subscriber.name}")
      IO.puts("Number: #{subscriber.number}")
      IO.puts("Calls: ")
      IO.inspect(subscriber.calls)
      IO.puts("Recharges:")
      IO.inspect(subscriber.plan.recharges)
      IO.puts("Total calls: #{Enum.count(subscriber.calls)}")
      IO.puts("Total recharges: #{Enum.count(subscriber.plan.recharges)}")
      IO.puts("======================================================")
    end)

    Enum.each(Subscriber.find_all_post_paid(), fn s ->
      subscriber = PostPaid.print_bill(month, year, s.number)
      IO.puts("PostPaid Bill Subscriber: #{subscriber.name}")
      IO.puts("Number: #{subscriber.number}")
      IO.puts("Calls: ")
      IO.inspect(subscriber.calls)
      IO.puts("Total calls: #{Enum.count(subscriber.calls)}")
      IO.puts("Total values: #{subscriber.plan.value}")
      IO.puts("========================================================")
    end)
  end
end
