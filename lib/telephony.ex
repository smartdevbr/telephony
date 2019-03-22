defmodule Telephony do
  def start() do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))
  end

  def insert_subscriber(name, number, plan), do: Subscriber.create(name, number, plan)

  def list_all_subscriber(), do: Subscriber.find_all()

  def make_call(plan, number, date, duration) do
    cond do
      plan == :pre ->
        Prepaid.make_call(number, date, duration)

      plan == :post ->
        PostPaid.make_call(number, date, duration)
    end
  end

  def make_recharge(date, value, number), do: Recharge.new(date, value, number)

  def find_by_number(number, key \\ :all), do: Subscriber.find_by_number(number, key)

  def print_all_bills(month, year) do
    Enum.each(Subscriber.find_all_pre_paid(), fn s ->
      subscriber = Prepaid.print_bill(month, year, s.number)
      IO.puts("Prepaid bill Subscriber #{subscriber.name}")
      IO.puts("Number: #{subscriber.number}")
      IO.puts("Calls:")
      IO.inspect(subscriber.calls)
      IO.puts("Recharges: ")
      IO.inspect(subscriber.plan.recharges)
      IO.puts("Total calls: #{Enum.count(subscriber.calls)}")
      IO.puts("Total recharges: #{Enum.count(subscriber.plan.recharges)}")
      IO.puts("===========================================================")
    end)

    Enum.each(Subscriber.find_all_post_paid(), fn s ->
      subscriber = PostPaid.print_bill(month, year, s.number)
      IO.puts("Postpaid bill Subscriber #{subscriber.name}")
      IO.puts("Number: #{subscriber.number}")
      IO.puts("Calls:")
      IO.inspect(subscriber.calls)
      IO.puts("Total calls: #{Enum.count(subscriber.calls)}")
      IO.puts("Total value: #{subscriber.plan.value}")
      IO.puts("===========================================================")
    end)
  end
end
