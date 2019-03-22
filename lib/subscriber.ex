defmodule Subscriber do
  @moduledoc """
    Create Subscribers, update, delete, list all...
  """

  @subscribers %{:pre => "pre.txt", :post => "post.txt"}

  defstruct name: nil, number: nil, plan: nil, calls: []

  @doc """
  To find a subscriber pass the `number` and `key` with :all, :pre and :post

  ## Examples
      iex> Subscriber.create("Steve", "1238", :pre)
      iex> Subscriber.find_by_number("1238")
      %Subscriber{
            name: "Steve",
            number: "1238",
            plan: %Prepaid{credits: 0, recharges: []}
      }
  """
  def find_by_number(number, key \\ :all), do: find(number, key)

  defp find(number, :all), do: Enum.find(find_all(), &(&1.number == number))
  defp find(number, :pre), do: Enum.find(find_all_pre_paid(), &(&1.number == number))
  defp find(number, :post), do: Enum.find(find_all_post_paid(), &(&1.number == number))

  @doc """
    Create a subscriber passing the plan prepaid or postpaid
    if subscriber already exist return a message `Subscriber already registered`

    ## Examples
        iex> Subscriber.create("Steve", "1238", :pre)
        :ok
        iex> Subscriber.create("Steve", "1238", :pre)
        "Subscriber already registered"
  """
  def create(name, number, :pre), do: create(name, number, %Prepaid{})
  def create(name, number, :post), do: create(name, number, %PostPaid{})

  def create(name, number, plan) do
    case find_by_number(number) do
      nil ->
        subscriber = %Subscriber{name: name, number: number, plan: plan}

        (read_file(@subscribers[validate_plan(subscriber)]) ++ [subscriber])
        |> :erlang.term_to_binary()
        |> write_subscribers(subscriber)

      _subscriber ->
        "Subscriber already registered"
    end
  end

  @doc """
   receives a `subscribers_list` and a new `subscriber`, validate plan and save into pre.txt or post.txt
  """
  def write_subscribers(subscribers_list, subscriber) do
    File.write(@subscribers[validate_plan(subscriber)], subscribers_list)
  end

  @doc """
    updates a subscriber into a list 
    if subscriber has the same plan save the subscriber or throw a message `Subscriber needs to have the same plan`
  """
  def update(number, subscriber) do
    {old_subscriber, subscribers_list} = delete_item(number)

    case subscriber.plan.__struct__ == old_subscriber.plan.__struct__ do
      true ->
        (subscribers_list ++ [subscriber])
        |> :erlang.term_to_binary()
        |> write_subscribers(subscriber)

      false ->
        "Subscriber needs to have the same plan"
    end
  end

  @doc """
   To delete a subscriber, just need to pass a `number`
  """
  def delete(number) do
    {subscriber, subscribers_list} = delete_item(number)

    subscribers_list
    |> :erlang.term_to_binary()
    |> write_subscribers(subscriber)
  end

  @doc """
   is private function to delete a subscriber inside the list
  """
  defp delete_item(number) do
    subscriber = find_by_number(number)
    {subscriber, List.delete(read_file(@subscribers[validate_plan(subscriber)]), subscriber)}
  end

  def find_all(), do: find_all_post_paid() ++ find_all_pre_paid()
  def find_all_post_paid(), do: read_file(@subscribers[:post])
  def find_all_pre_paid(), do: read_file(@subscribers[:pre])

  defp validate_plan(subscriber) do
    case subscriber.plan.__struct__ == PostPaid do
      true -> :post
      false -> :pre
    end
  end

  defp read_file(file_name) do
    case File.read(file_name) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _error} -> "Failed to read the file"
    end
  end
end
