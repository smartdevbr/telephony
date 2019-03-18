defmodule Recharge do

    defstruct date: nil, value: nil

    def new(date, value, number) do 
        subscriber = Subscriber.find_by_number(number, :pre)
        prepaid = subscriber.plan

        prepaid = %Prepaid{prepaid | 
            credits: prepaid.credits + value,
            recharges: prepaid.recharges ++ [%Recharge{date: date, value: value}]    
        }
        subscriber_update = %Subscriber{subscriber | plan: prepaid}
        Subscriber.update(number, subscriber_update)
    end

end