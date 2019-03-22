defmodule PostPaidTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  describe "call" do
    test "should make a call" do
      Subscriber.create("Gustavo", "1197778490", :post)
      date = DateTime.utc_now()
      assert PostPaid.make_call("1197778490", date, 5) == :ok
    end
  end

  describe "tests about bills" do
    test "print a bill" do
      Subscriber.create("Gustavo", "1197778490", :post)
      date = DateTime.utc_now()
      PostPaid.make_call("1197778490", date, 3)

      subscriber = PostPaid.print_bill(date.month, date.year, "1197778490")

      assert subscriber.number == "1197778490"
      assert Enum.count(subscriber.calls) == 1
      assert subscriber.plan.value == 3.12
    end
  end
end
