defmodule XKNodesSetterTest do
  use ExUnit.Case
  doctest XK

  test "Set a node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_short_content())
    # val = XK.set_node(xml, [:Bookstore, :Booking, :Other], "wally")
    # val = XK.set_node(xml, [:Bookstore, :Bookings, :Other, :undefined], "wally")
    val = XK.set_node(xml, [:Bookstore, :Booking, :Other, :undefined], "wally")
    # val = XK.set_node(xml, [:Bookstore, :Booking, :International, :ISBN], "wally")
    IO.puts ""
    IO.puts "VALUE: "
    IO.inspect val
    # assert val == "1"
  end
end
