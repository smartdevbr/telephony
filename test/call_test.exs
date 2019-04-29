defmodule CallTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  describe "make Calls" do
    test "make a post paid call" do
      Subscriber.create("Gustavo", "1197778490", :post)
      subscriber = Subscriber.find_by_number("1197778490", :post)
      date = DateTime.utc_now()

      assert Call.register_call(subscriber, date, 10) == :ok
      calls = Subscriber.find_by_number("1197778490", :post).calls
      assert Enum.count(calls) == 1
      assert List.first(calls) == %Call{date: date, duration: 10}
    end

    test "make a pre paid call" do
      Subscriber.create("Gustavo", "1197778490", :pre)
      subscriber = Subscriber.find_by_number("1197778490", :pre)
      date = DateTime.utc_now()
      Recharge.new(date, 30, "1197778490")

      assert Call.register_call(subscriber, date, 10) == :ok
      calls = Subscriber.find_by_number("1197778490", :pre).calls
      assert Enum.count(calls) == 1
      assert List.first(calls) == %Call{date: date, duration: 10}
    end
  end
end
