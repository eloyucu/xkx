defmodule XKNodesSetterTest do
  use ExUnit.Case
  doctest XKX

  test "Set the first occurrence of a node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node(xml, [:Bookstore, :Booking, :Other], "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_first_occurrence"))
    assert content == xml
  end
  test "Set the first occurrence node with a non string value" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node(xml, [:Bookstore, :Booking, :Other], [final: [attrs: [], value: [foo: [attrs: [], value: "BAR"]]]])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_first_not_string"))
    assert content == xml
  end
  test "Set a non existing node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    bookings = XKX.set_node(xml, [:Bookstore, :Bookings, :Other, :undefined], "wally")
    undefined = XKX.set_node(xml, [:Bookstore, :Booking, :Other, :undefined], "wally")
    assert bookings == xml
    assert undefined == xml
  end
  # test "Create a non existing node" do
  #   {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
  #   # bookings = XKX.create_node(xml, [:Bookstore, :Bookings, :Other, :undefined], "wally")
  #   undefined = XKX.create_node(xml, [:Bookstore, :Booking, :International, :undefined], "wally")
  #   # assert bookings == xml
  #   # assert undefined == xml
  #   IO.inspect undefined
  # end
  test "Set a node all ocurrences in the same path" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_multiple(xml, [:Bookstore, :Booking, :Other], "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_all_nodes_same_path"))
    assert content == xml
  end
  test "Set a node all ocurrences in the same path (deeper)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_multiple(xml, [:Bookstore, :Booking, :Other], "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("short_content_multiply_other"))
    assert xml == content
  end
  test "Set a node all ocurrences in all paths" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_node_multiple_all(xml, [:Bookstore, :Book, :Name], "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_all_ocu_all_path"))
    assert xml == content
  end
  test "Set a node all ocurrences in all paths (mini)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_mini_content())
    {xml, content} =
      XKX.set_node_multiple_all(xml, [:Bookstore, :Book, :ISBN], "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_all_ocu_all_path_mini"))
    assert xml == content
  end
  test "Set a node all ocurrences in all paths (deeper)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    {xml, content} =
      XKX.set_node_multiple_all(xml, [:Bookstore, :Book, :Author, :Name, :Given, :ISBN, :special], "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_all_ocu_all_path_deep"))
    assert xml == content
  end
  test "Set a node all ocurrences in all paths (deeper) II" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_multiple_all(xml, [:Bookstore, :Booking, :Other], "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("short_content_multiply_other_all"))
    assert xml == content
  end
end
