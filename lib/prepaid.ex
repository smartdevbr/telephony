defmodule Prepaid do
    defstruct credits: 0, recharges: []

    def make_call(number, date, duration) do 
        subscriber = Subscriber.find_by_number(number, :pre)
        cost = 1.45 * duration

        cond do
            cost <= subscriber.plan.credits -> 
                "you can make the call"
            true ->
                "You are not allowed to make the call. please make a recharge!"
        end
    end
end