defmodule Subscriber do

    @subscribers("subscribers.txt")

    defstruct name: nil, number: nil, plan: nil

    def find_by_number(number), do: Enum.find read_file(@subscribers), &(&1.number == number)

    def create(name, number, plan) do
        case find_by_number number do
            nil -> 
                list_subscribers = read_file(@subscribers) ++ [ %Subscriber{name: name, number: number, plan: plan} ]
                |> :erlang.term_to_binary()
                File.write(@subscribers, list_subscribers)
            _subscriber -> "Subscriber already registered"
        end
    end

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