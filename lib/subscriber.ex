defmodule Subscriber do

    @moduledoc """
    This module is to manipulate Subscribers 
    """

    @subscribers %{:pre => "pre.txt", :post => "post.txt"}



    defstruct name: nil, number: nil, plan: nil

    @doc """
    To find a subscriber pass the `number`

    ## Examples
        iex> Subscriber.find_by_number("1238")
        %Subscriber{name: "Steve", number: "1238", plan: "pre"}
    """
    def find_by_number(number, key \\ :all), do: find(number, key)

    defp find(number, :all), do: Enum.find find_all(), &(&1.number == number)
    defp find(number, :pre), do: Enum.find find_all_pre_paid(), &(&1.number == number)
    defp find(number, :post), do: Enum.find find_all_pre_post_paid(), &(&1.number == number)


    @doc """
    Create a new subscriber in a file

    ## Examples
        iex> Subscriber.delete("1238")
        iex> Subscriber.create("Steve", "1238", "pre")
        :ok
    """
    def create(name, number, :pre), do: create(name, number, %Prepaid{})
    def create(name, number, :post), do: create(name, number, %PostPaid{})

    def create(name, number, plan) do
        case find_by_number number do
            nil -> 
                subscriber =  %Subscriber{name: name, number: number, plan: plan}
                list_subscribers = read_file(@subscribers[validate_plan[subscriber]]) ++ [ subscriber ]
                |> :erlang.term_to_binary()
                File.write(@subscribers, list_subscribers)
            _subscriber -> "Subscriber already registered"
        end
    end

    @doc """
    Function to update subcribers
    """
    def update(number, subscriber) do
        subscribers_list = delete_item(number) ++ [subscriber]
        |> :erlang.term_to_binary()
        File.write(@subscribers, subscribers_list)
    end

    def delete(number) do
        subscribers_list = delete_item(number)
        |> :erlang.term_to_binary()
        File.write(@subscribers, subscribers_list)
    end

    defp delete_item(number), do: List.delete(read_file(@subscribers), find_by_number(number))

    def find_all(), do: find_all_pre_post_paid() ++ find_all_pre_paid()
    def find_all_pre_post_paid(), do: read_file(@subscribers[:post])
    def find_all_pre_paid(), do: read_file(@subscribers[:pre])

    defp validate_plan(subscriber) do
        case subscriber.plan.__struct == PostPaid do
            true -> :post
            false -> :pre
        end
    end

    defp read_file(file_name) do
        case File.read(file_name) do 
            {:ok, binary} -> :erlang.binary_to_term binary
            {:error, _error}  -> "Failed to read the file"
        end
    end
end