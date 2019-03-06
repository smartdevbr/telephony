defmodule TelephonyTest do
  use ExUnit.Case
  doctest Telephony

  test "greets the world" do
    assert Telephony.hello("Gustavo") == "Hello Gustavo"
  end
end
