defmodule PostPaid do
  defstruct value: 0

  @minute_value 1.04

  @doc """
    This function is used to register a call from a postpaid subscriber on a date and with the duration in 
    minutes given by its arguments.
    The function must store the call in the call list and the cost of a postpaid call is `1.04` per minute
  """
  def make_call(number, date, duration) do
    subscriber = Subscriber.find_by_number(number, :post)
    Call.register_call(subscriber, date, duration)
  end

  @doc """
    This function should be used to print subscriber data, 
    calls made in the month,
    number of calls made in the month, 
    and how much will be charged for all calls of the month and year
  """
  def print_bill(month, year, number) do
    subscriber = Bill.print_bill(month, year, number, :post)

    total_values =
      Enum.map(subscriber.calls, &(&1.duration * @minute_value))
      |> Enum.sum()

    %Subscriber{subscriber | plan: %PostPaid{value: total_values}}
  end
end
