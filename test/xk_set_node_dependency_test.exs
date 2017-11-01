defmodule XKNodesSetterByDependencyTest do
  use ExUnit.Case
  doctest XKX

  test "Set a node depending on its old value" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_by_dependency(xml, [:Bookstore, :Booking, :Other], [something: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("set_by_dependency_simple_node"))
    assert content == xml
  end
  test "Set a node depending on its old value II" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_by_dependency(xml, [:Bookstore, :Booking, :Other], [something_2: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_short_content())
    assert content == xml
  end
  test "Set multiple nodes depending on its old value" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_multiple_by_dependency(xml, [:Bookstore, :Booking, :Other], [something_2: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("set_by_dependency_multiple_nodes"))
    assert content == xml
  end
  test "Set multiple nodes depending on its old value II" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_duplicate_nodes_content())
    {xml, content} =
      XKX.set_node_multiple_by_dependency(xml, [:Bookstore, :Booking, :Other], [something: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("set_by_dependency_multiple_duplicates_nodes"))
    assert content == xml
  end
  test "Set multiple nodes different paths depending on its old value" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_duplicate_nodes_content())
    {xml, content} =
      XKX.set_node_multiple_all_by_dependency(xml, [:Bookstore, :Booking, :Other], [something: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("set_by_dependency_multiple_duplicates_nodes_all"))
    assert content == xml
  end
end
