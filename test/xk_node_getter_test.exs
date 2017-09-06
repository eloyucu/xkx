defmodule XKNodesGetterTest do
  use ExUnit.Case
  doctest XK


  test "Get the value of a particular node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node_value(xml, [:Bookstore, :Book])
    assert val == [ISBN: [attrs: [type: "international"], value: "ISBN_1"], Name: [attrs: [], value: "The Last Letcture"], Author: [attrs: [], value: "Randy Pausch"]]
  end
  test "Get the value of first son of a node and after get value from a concrete son" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node_value(xml, [:Bookstore, :Book])
    val = XK.get_node_value(val, [:Author])
      assert val == "Randy Pausch"
  end
  test "Get a particular node with all its structure" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node(xml, [:Bookstore, :Book, :ISBN])
    assert val == [attrs: [type: "international"], value: "ISBN_1"]
  end
  test "Get a particular node with all its structure (not first node)" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node(xml, [:Bookstore, :Book, :Unique])
    assert val == [attrs: [valid: "true"], value: "true"]
  end
  test "Get the value of a node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node_value(xml, [:Bookstore, :Book, :ISBN])
    assert val == "ISBN_1"
  end
  test "Get the value of a node deep" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node_value(xml, [:Bookstore, :Book, :ISBN, :special])
    assert val == "ISBN_3"
  end
  test "Get the value of a node (not first node)" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node_value(xml, [:Bookstore, :Book, :Unique])
    assert val == "true"
  end
  test "Get the value of the deepest node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_deep_content())
    name = XK.get_node_value(xml, [:Bookstore, :Book, :Author, :Name])
    special = XK.get_node_value(xml, [:Bookstore, :Book, :Author, :Name, :Given, :ISBN, :special])
    assert name == [Given: [attrs: [], value: [ISBN: [attrs: [type: "EU"], value: [special: [attrs: [attr: "value"], value: "ISBN_3"]]]]]]
    assert special == "ISBN_3"
  end
  test "Get the structure of the deepest node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_deep_content())
    name = XK.get_node(xml, [:Bookstore, :Book, :Author, :Name, :Given])
    special = XK.get_node(xml, [:Bookstore, :Book, :Author, :Name, :Given, :ISBN, :special])
    assert special == [attrs: [attr: "value"], value: "ISBN_3"]
    assert name ==  [attrs: [], value: [ISBN: [attrs: [type: "EU"], value: [special: [attrs: [attr: "value"], value: "ISBN_3"]]]]]
  end
  test "Get wrong value of a node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node_value(xml, [:Bookstores, :Book])
    assert val == nil
  end
  test "Get wrong value of a not existing node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node_value(xml, [:Bookstore, :Book, :Unique, :undefined])
    assert val == nil
  end
  test "Get wrong structure or value of a node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node(xml, [:Bookstores, :Book])
    assert val == nil
  end
  test "Get wrong structure or value of a not existing node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    val = XK.get_node(xml, [:Bookstore, :Book, :Unique, :undefined])
    assert val == nil
  end

end
