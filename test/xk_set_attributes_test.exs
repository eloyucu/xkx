defmodule XKAttributesSetterTest do
  use ExUnit.Case
  doctest XK


  test "Set attribute of the first occurrence of a node (Main node)" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XK.set_node_attr(xml, [:Bookstore], :id, "wally")
      |> XK.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_main"))
    assert content == xml
  end
  test "Set attribute of the first occurrence of a node" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XK.set_node_attr(xml, [:Bookstore, :Book, :ISBN], :type, "wally")
      |> XK.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute"))
    assert content == xml
  end
  test "Set attribute of the first occurrence of a node II" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    {xml, content} =
      XK.set_node_attr(xml, [:Bookstore, :Book, :Name], :type, "wally")
      |> XK.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_II"))
    assert content == xml
  end
  test "Set a attribute of the first occurrence of a node III" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XK.set_node_attr(xml, [:Bookstore, :Booking], :id, "wally")
      |> XK.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_preserve_other_short"))
      assert content == xml
    end

    # NO FURRULA
  # test "Set a list of attributes of the first occurrence of a node (Main node)" do
  #   {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
  #   {xml, content} =
  #     XK.set_node_attr(xml, [:Bookstore], [id: "wally", wally: "more_wally"])
  #     |> XK.convert_K2X
  #     |> TestHelper.normalize(TestHelper.get_match("content_set_attributes_main"))
  #   assert content == xml
  # end
  # NO FURRULA
  # test "Set all attributes of the first occurrence of a node" do
  #   {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
  #   {xml, content} =
  #     XK.set_node_attr(xml,  [:Bookstore, :Book, :ISBN], [id: "wally", wally: "more_wally"])
  #     |> XK.convert_K2X
  #     |> IO.inspect
  #     |> TestHelper.normalize(TestHelper.get_match("content_set_attributes"))
  #   assert content == xml
  # end
  # NO FURRULA
  # test "Set all attributes of the first occurrence of a node II" do
  #   {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_short_content())
  #   {xml, content} =
  #     XK.set_node_attr(xml, [:Bookstore, :Booking, :Other], [class: "wally"])
  #     |> XK.convert_K2X
  #     |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_short"))
  #   assert content == xml
  # end
  # FURRULA
  test "Set a attribute of the sequence of nodes of the first occurrence of a father node (short xml)" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_short_content())
    {xml, content} =
      XK.set_attribute_multiple(xml, [:Bookstore, :Booking, :Other], [class: "wally"])
      |> XK.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("content_set_attribute_sequence"))
    assert content == xml
  end
end
