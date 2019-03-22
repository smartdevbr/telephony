defmodule Telephony do
  @moduledoc """
    The system should be based on a menu with the following options. 
    And before you start anything you must execute `Telephony.start()`
  """

  @doc """
    Start the system
  """
  def start() do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))
  end

  @doc """
    This function is invoked when it receives a subscriber with all its information filled and stores in the list of subscribers  
  """
  def insert_subscriber(name, number, plan), do: Subscriber.create(name, number, plan)

  @doc """
    The function displays the postpaid subscriber data and then the infomations of the prepaid subscribers
  """
  def list_all_subscriber(), do: Subscriber.find_all()

  @doc """
    The function receives the type of the `plan`, the `number` of the subscriber the `duration` and the `date`, 
    records the call of the subscriber
  """
  def make_call(plan, number, date, duration) do
    cond do
      plan == :pre ->
        Prepaid.make_call(number, date, duration)

      plan == :post ->
        PostPaid.make_call(number, date, duration)
    end
  end

  @doc """
    The function receives the number of the subscriber the value and the date of recharge and registers a recharge for the prepaid subscriber
  """
  def make_recharge(date, value, number), do: Recharge.new(date, value, number)

  @doc """
    Returns a subscriber that has the same number as the one provided as an argument to the function.
    If the subscriber is not found the function returns `nil`
  """
  def find_by_number(number, key \\ :all), do: Subscriber.find_by_number(number, key)

  @doc """
    The function should request a month and year and print the invoices for this month and year 
    of all prepaid subscribers and then postpaid subscribers
  """
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
