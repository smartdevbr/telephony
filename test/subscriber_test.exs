defmodule SubscriberTest do 
    use ExUnit.Case


    test "create a subscriber" do 
        Subscriber.delete("1197778490")
        assert :ok == Subscriber.create("Gustavo", "1197778490", "pre")
    end
end