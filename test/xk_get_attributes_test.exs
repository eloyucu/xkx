defmodule XKAttributesGetterTest do
  use ExUnit.Case
  doctest XKX

  test "Get an Attribute from node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_attrs(xml, [:Bookstore, :Book], :id)
    assert val == "1"
  end
  test "Get an Attribute from node (second case)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_attrs(xml, [:Bookstore, :Book, :ISBN], :type)
    assert val == "international"
  end
  test "Get an Attribute from node (not the first)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_attrs(xml, [:Bookstore, :Book], :seller)
    assert val == "second"
  end
  test "Get bad Attribute from node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_attrs(xml, [:Bookstore, :Book], :ids)
    assert val == nil
  end
  test "Get the attributes of the deepest node (not the first)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    type = XKX.get_node_attrs(xml, [:Bookstore, :Book, :Author, :Name, :Given, :ISBN], :type)
    attr = XKX.get_node_attrs(xml, [:Bookstore, :Book, :Author, :Name, :Given, :ISBN, :special], :attr)
    assert type == "EU"
    assert attr ==  "value"
  end
  # test "Get an Attribute from node after get a node" do
  #   {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
  #   val =
  #   XKX.get_node(xml, [:Bookstore, :Book])
  #   |> XKX.get_node_attrs([:id])
  #   assert val == "1"
  # end
  # test "Get an Attribute from node after get a node (not the first)" do
  #   {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
  #   val = XKX.get_node(xml, [:Bookstore, :Book, :Unique])
  #   val = XKX.get_node_attrs(val, [:valid])
  #   assert val == "true"
  # end
end
