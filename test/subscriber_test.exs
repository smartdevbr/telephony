defmodule SubscriberTest do 
    use ExUnit.Case


    test "create a subscriber" do 
        Subscriber.delete("1197778490")
        assert Subscriber.create("Gustavo", "1197778490", "pre") == :ok
    end

    test "delete a subscriber" do 
        assert Subscriber.delete("1197778490") == :ok
    end
    
end