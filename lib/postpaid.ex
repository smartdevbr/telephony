defmodule PostPaid do
    defstruct value: 0

    def make_call(number, date, duration) do
        subscriber = Subscriber.find_by_number(number, :post)
        Call.register_call(subscriber, date, duration)
    end
end