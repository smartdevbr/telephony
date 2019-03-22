defmodule Prepaid do
  @price_per_minute 1.45

  defstruct credits: 0, recharges: []

  def make_call(number, date, duration) do
    subscriber = Subscriber.find_by_number(number, :pre)
    cost = @price_per_minute * duration

    cond do
      cost <= subscriber.plan.credits ->
        Call.register_call(subscriber, cost, date, duration)

      true ->
        "You are not allowed to make the call. please make a recharge!"
    end
  end

  def print_bill(month, year, number) do
    Bill.print_bill(month, year, number, :pre)
  end
end
