defmodule XKAttributesSetterTest do
  use ExUnit.Case
  doctest XK

  test "Set attribute of the first occurrence of a node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XK.set_node_attr(xml, [:Bookstore, :Book, :ISBN], :type, "wally")
      |> XK.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute"))
    assert content == xml
  end
  test "Set attribute of the first occurrence of a node (Main node)" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XK.set_node_attr(xml, [:Bookstore], :id, "wally")
      |> XK.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribut_main"))
    assert content == xml
  end
end
