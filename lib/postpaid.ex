defmodule PostPaid do
    defstruct value: 0

    @minute_value 1.04

    def make_call(number, date, duration) do
        subscriber = Subscriber.find_by_number(number, :post)
        Call.register_call(subscriber, date, duration)
    end


    def print_bill(month, year, number) do
        subscriber = Bill.print_bill(month, year, number, :post)
        total_values = Enum.map(subscriber.calls, &(&1.duration * @minute_value))
        |> Enum.sum()

        %Subscriber{subscriber | plan: %PostPaid{value: total_values}}
    end

end