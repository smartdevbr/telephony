defmodule RechargeTest do
  use ExUnit.Case

  setup do
    File.write("pre.txt", :erlang.term_to_binary([]))
    File.write("post.txt", :erlang.term_to_binary([]))

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("post.txt")
    end)
  end

  describe "should test recharge" do
    test "make a recharge" do
      Subscriber.create("Gustavo", "1197778490", :pre)

      date = DateTime.utc_now()
      assert Recharge.new(date, 30, "1197778490") == :ok
      [recharge | _tail] = Subscriber.find_by_number("1197778490").plan.recharges
      assert recharge.value == 30
      assert recharge.date == date
    end
  end
end
