defmodule SubscriberTest do 
    use ExUnit.Case
    doctest Subscriber

    setup do 
        File.write("pre.txt", :erlang.term_to_binary([]))
        File.write("post.txt", :erlang.term_to_binary([]))


        on_exit fn -> 
            File.rm("pre.txt")
            File.rm("post.txt")
        end
    end

    @subscribers("subscribers.txt")
    @subscriber_update %Subscriber{name: "Update ok", number: "11234", plan: %PostPaid{value: nil}}


    describe "tests for creating a subscriber" do 
        test "create a prepaid subscriber" do 
            assert Subscriber.create("Gustavo", "1197778490", :pre) == :ok
        end

        test "create a postpaid subscriber" do 
            assert Subscriber.create("Gustavo", "1197778490", :post) == :ok
        end
        
        test "throw a message when subscriber registered" do 
            Subscriber.create("Gustavo", "1197778490", :pre)
            assert Subscriber.create("Gustavo", "1197778490", :pre) == "Subscriber already registered"
        end
    end

    describe "find_by_number" do
        test "should return a subscriber " do 
            Subscriber.create("Gustavo", "1197778490", :pre)
            assert Subscriber.find_by_number("1197778490").name == "Gustavo"
        end

        test "should return a prepaid subscriber " do 
            Subscriber.create("Gustavo", "1197778490", :pre)
            assert Subscriber.find_by_number("1197778490", :pre).name == "Gustavo"
        end

        test "should return a postpaid subscriber " do 
            Subscriber.create("Gustavo", "1197778490", :post)
            assert Subscriber.find_by_number("1197778490", :post).name == "Gustavo"
        end

    end

    describe "update" do
        test "update subscriber" do
            Subscriber.create("Test update", "11234", :post)
            assert Subscriber.update("11234", @subscriber_update) == :ok
        end

        test "should throw a message error" do
            Subscriber.create("Test update", "11234", :pre)
            assert Subscriber.update("11234", @subscriber_update) == "Subscriber needs to have the same plan"
        end
    end

    describe "delete" do
        test "delete a subscriber" do 
            Subscriber.create("Gustavo", "1197778490", :pre)
            assert Subscriber.delete("1197778490") == :ok
        end
    end



    
end