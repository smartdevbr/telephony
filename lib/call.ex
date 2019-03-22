defmodule Call do
    defstruct date: nil, duration: nil

    def register_call(subscriber, cost, date, duration) do
       plan = subscriber.plan
       plan = %Prepaid{plan | credits: plan.credits - cost}

       subscriber_update = %Subscriber{subscriber | 
        plan: plan,
        calls: subscriber.calls ++ [%Call{date: date, duration: duration}]
        }
        Subscriber.update(subscriber.number, subscriber_update)
    end

    def register_call(subscriber, date, duration) do
        subscriber_update = %Subscriber{subscriber |
            calls: subscriber.calls ++ [%Call{date: date, duration: duration}]
        }
        Subscriber.update(subscriber.number, subscriber_update)
    end
end