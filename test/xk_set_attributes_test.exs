defmodule XKAttributesSetterTest do
  use ExUnit.Case
  doctest XKX


  test "Set attribute of the first occurrence of a node (Main node)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore], :id, "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_main"))
    assert content == xml
  end
  test "Set attribute of the first occurrence of a node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore, :Book, :ISBN], :type, "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute"))
    assert content == xml
  end
  test "Set attribute of the first occurrence of a node II" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore, :Book, :Name], :type, "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_II"))
    assert content == xml
  end
  test "Set a attribute of the first occurrence of a node III" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore, :Booking], :id, "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_preserve_other_short"))
      assert content == xml
  end
  test "Set all attributes of the first occurrence of a node IV" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore, :Booking, :International, :ISBN], :class, "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_deep"))
    assert content == xml
  end
  test "Set all attributes of the first occurrence of a node V" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore, :Booking, :International, :ISBN], [class: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_deep_by_list"))
    assert content == xml
  end
  test "Set a list of attributes of the first occurrence of a node (Main node)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore], [id: "wally", wally: "more_wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attributes_main"))
    assert content == xml
  end
  test "Apply a sequence of attribute settings on the first occurrence of a node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_node_attr(xml,  [:Bookstore, :Book, :ISBN], :id, "wally")
      |> XKX.set_node_attr([:Bookstore, :Book, :ISBN], :wally, "more_wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attributes"))
    assert content == xml
  end
  test "Set all attributes of the first occurrence of a node II" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore, :Booking, :Other], [class: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_short"))
    assert content == xml
  end
  test "Set all attributes of the first occurrence of a node III" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_node_attr(xml, [:Bookstore, :Booking, :Other], :class, "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_short"))
    assert content == xml
  end
  test "Set a attribute of the sequence of nodes of the first occurrence of a father node (short xml)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XKX.set_attribute_multiple(xml, [:Bookstore, :Booking, :Other], [class: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_sequence"))
    assert content == xml
  end
  test "Set a list of attributes nodes" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_attribute_multiple_all(xml, [:Bookstore, :Book, :ISBN], :type, "wally")
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attributes_list_nodes"))
    assert content == xml
  end
  test "Set a list of attributes nodes using list" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XKX.set_attribute_multiple_all(xml, [:Bookstore, :Book, :ISBN], [type: "wally"])
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attributes_list_nodes"))
    assert content == xml
  end
end
