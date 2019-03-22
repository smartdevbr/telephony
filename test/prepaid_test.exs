defmodule PrepaidTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  describe "make_call" do
    test "should not make call" do
      Subscriber.create("Gustavo", "1197778490", :pre)
      date = DateTime.utc_now()

      assert Prepaid.make_call("1197778490", date, 3) ==
               "You are not allowed to make the call. please make a recharge!"
    end

    test "should make call" do
      Subscriber.create("Gustavo", "1197778490", :pre)
      date = DateTime.utc_now()
      Recharge.new(date, 30, "1197778490")

      assert Prepaid.make_call("1197778490", date, 3) == :ok
    end
  end

  describe "tests about bills" do
    test "print a bill" do
      Subscriber.create("Gustavo", "1197778490", :pre)
      date = DateTime.utc_now()
      Recharge.new(date, 30, "1197778490")
      Prepaid.make_call("1197778490", date, 3)

      subscriber = Prepaid.print_bill(date.month, date.year, "1197778490")

      assert subscriber.number == "1197778490"
      assert Enum.count(subscriber.calls) == 1
      assert Enum.count(subscriber.plan.recharges) == 1
    end
  end
end
