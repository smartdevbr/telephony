defmodule Subscriber do

    @moduledoc """
    This module is to manipulate Subscribers 
    """

    @subscribers("subscribers.txt")

    defstruct name: nil, number: nil, plan: nil

    @doc """
    To find a subscriber pass the `number`

    ## Examples
        iex> Subscriber.find_by_number("1238")
        %Subscriber{name: "Steve", number: "1238", plan: "pre"}
    """
    def find_by_number(number), do: Enum.find read_file(@subscribers), &(&1.number == number)

    @doc """
    Create a new subscriber in a file

    ## Examples
        iex> Subscriber.delete("1238")
        iex> Subscriber.create("Steve", "1238", "pre")
        :ok
    """
    def create(name, number, plan) do
        case find_by_number number do
            nil -> 
                list_subscribers = read_file(@subscribers) ++ [ %Subscriber{name: name, number: number, plan: plan} ]
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

    def read_file(file_name) do
        case File.read(file_name) do 
            {:ok, binary} -> :erlang.binary_to_term binary
            {:error, _error}  -> "Failed to read the file"
        end
    end
end