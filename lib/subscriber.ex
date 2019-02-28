defmodule Subscriber do
    defstruct name: nil, number: nil, plan: nil

    def find_by_number(number), do: Enum.find read_file("subscribers.txt"), &(&1.number == number)

    def create(name, number, plan) do 
        list_subscribers = read_file("subscribers.txt") ++ [ %Subscriber{name: name, number: number, plan: plan} ]
        |> :erlang.term_to_binary()
        File.write("subscribers.txt", list_subscribers)
    end

    def read_file(file_name) do
        case File.read(file_name) do 
            {:ok, binary} -> :erlang.binary_to_term binary
            {:error, error}  -> "Failed to read the file"
        end
    end
end