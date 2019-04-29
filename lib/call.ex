defmodule Call do
  defstruct date: nil, duration: nil


  @doc """
    register call
  """
  def register_call(subscriber, date, duration) do
    subscriber_update = %Subscriber{
      subscriber
      | calls: subscriber.calls ++ [%Call{date: date, duration: duration}]
    }

    Subscriber.update(subscriber.number, subscriber_update)
  end
end
