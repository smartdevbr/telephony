defmodule Subscriber do
    defstruct name: nil, number: nil, plan: nil

    def find_by_number(number), do: Enum.find read_file("subscribers.txt"), &(&1.number == number)

    def create(name, number, plan) do
        case find_by_number number do
            nil -> 
                list_subscribers = read_file("subscribers.txt") ++ [ %Subscriber{name: name, number: number, plan: plan} ]
                |> :erlang.term_to_binary()
                File.write("subscribers.txt", list_subscribers)
            _subscriber -> "Subscriber already registered"
        end
    end

    def delete(number) do
        subscribers_list = List.delete(read_file("subscribers.txt"), find_by_number(number))
        |> :erlang.term_to_binary()
        File.write("subscribers.txt", subscribers_list)
    end

    def read_file(file_name) do
        case File.read(file_name) do 
            {:ok, binary} -> :erlang.binary_to_term binary
            {:error, _error}  -> "Failed to read the file"
        end
    end
end