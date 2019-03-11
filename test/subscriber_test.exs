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
    @subscriber_update %Subscriber{name: "Update ok", number: "11234", plan: "pos"}


    describe "tests for creating a subscriber" do 
        test "create a subscriber" do 
            assert Subscriber.create("Gustavo", "1197778490", :pre) == :ok
        end
        
        test "throw a message when subscriber registered" do 
            Subscriber.create("Gustavo", "1197778490", :pre)
            assert Subscriber.create("Gustavo", "1197778490", :pre) == "Subscriber already registered"
        end
    end

    test "delete a subscriber" do 
        assert Subscriber.delete("1197778490") == :ok
    end

    test "should return a subscriber " do 
        Subscriber.create("Gustavo", "1197778490", "pre")
        assert Subscriber.find_by_number("1197778490").name == "Gustavo"
    end

    test "should read a file_name" do 
        [first_element | _tail] = Subscriber.read_file(@subscribers)
        assert first_element.name == "Josh"
    end

    test "should throw a error message when try to read a file does not exist" do
        assert Subscriber.read_file("subscribers") == "Failed to read the file"
    end

    test "should return a subscriber in find_by_number" do 
        Subscriber.create("Gustavo", "1197778490", "pre")
        assert Subscriber.find_by_number("1197778490").name == "Gustavo"
    end

    test "update subscriber" do
        Subscriber.create("Test update", "11234", "pos")
        assert Subscriber.update("11234", @subscriber_update) == :ok
    end
    
end