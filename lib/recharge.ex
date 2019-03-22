defmodule Recharge do
  @moduledoc """
    Module to register a Recharge
  """

  defstruct date: nil, value: nil

  @doc """
    This function is used to register a recharge of a prepaid subscriber, 
    on a date and with a value by its arguments. 
    The function must store the recharge in the recharge list, update the subscriber's credits
  """
  def new(date, value, number) do
    subscriber = Subscriber.find_by_number(number, :pre)
    prepaid = subscriber.plan

    prepaid = %Prepaid{
      prepaid
      | credits: prepaid.credits + value,
        recharges: prepaid.recharges ++ [%Recharge{date: date, value: value}]
    }

    subscriber_update = %Subscriber{subscriber | plan: prepaid}
    Subscriber.update(number, subscriber_update)
  end
end
