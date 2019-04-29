defmodule Prepaid do
  @moduledoc """
    make calls for for prepaid plan and print bills
  """

  @price_per_minute 1.45

  defstruct credits: 0, recharges: []

  @doc """
    This function is used to register a call from a prepaid subscriber on a
    date with a duration of minutes provided in its arguments.
    The function should check if the subscriber has enough credits to make the call.
    the cost of a prepaid call is `1.45` per minute.
    if the call is successful,
    it must be stored in the call list and the subscriber's credits must be updated,
    if it is not possible to display a message: `You are not allowed to make the call. please make a recharge!`
  """
  def make_call(number, date, duration) do
    subscriber = Subscriber.find_by_number(number, :pre)
    cost = @price_per_minute * duration

    cond do
      cost <= subscriber.plan.credits ->
        %Subscriber{ subscriber | plan:
          %Prepaid{subscriber.plan | credits: subscriber.plan.credits - cost}
        }
        |> Call.register_call(date, duration)
      true ->
        "You are not allowed to make the call. please make a recharge!"
    end
  end

  @doc """
    This function must be used to print the bill of a prepaid subscriber in a month given its arguments,
    the function should print the subscriber, month calls, month recharges,
    number of calls and number of recharges along with the credits of the subscriber
  """
  def print_bill(month, year, number) do
    Bill.print_bill(month, year, number, :pre)
  end
end
