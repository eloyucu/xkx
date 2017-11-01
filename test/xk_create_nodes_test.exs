defmodule XKCreateNodesTest do
  use ExUnit.Case
  doctest XKX

  test "Create a node on root (after)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_book = [Book: [attrs: [id: "4", class: "terror"],
      value: [Author: [attrs: [], value: "new one"]]]]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore], new_book, :after, false)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_first_node"))
    assert content == xml
  end
  test "Create a node on second node (after)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_author = [Author: [attrs: [chapters: "1-5-6"], value: "new one"]]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore, :Book], new_author, :after, false)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_second_node"))
      assert content == xml
  end
  test "Create a node on root (before)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_book = [Book: [attrs: [id: "4", class: "terror"],
      value: [Author: [attrs: [], value: "new one"]]]]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore], new_book, :before, false)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_first_node_before"))
    assert content == xml
  end
  test "Create a node on second node (before)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_author = [Author: [attrs: [chapters: "1-5-6"], value: "new one"]]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore, :Book], new_author, :before, false)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_second_node_before"))
      assert content == xml
  end

  test "Create a node on root (list-after)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_book = [
      [Book: [attrs: [id: "4", class: "terror"],
      value: [Author: [attrs: [], value: "new one"]]]],
      [Book: [attrs: [id: "5", class: "adventure"],
        value: [Author: [attrs: [], value: "LBA"]]]]
    ]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore], new_book, :after, true)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_first_node_list"))
    assert content == xml
  end
  test "Create a node on second node (list-after)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_author = [
      [Author: [attrs: [chapters: "1-5-6"], value: "new one"]],
      [Author: [attrs: [chapters: "2-5-7"], value: "Stephan"]]
    ]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore, :Book], new_author, :after, true)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_second_node_list"))
      assert content == xml
  end
  test "Create a node on root (list-before)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_book = [
      [Book: [attrs: [id: "4", class: "terror"],
      value: [Author: [attrs: [], value: "new one"]]]],
      [Book: [attrs: [id: "5", class: "adventure"],
        value: [Author: [attrs: [], value: "LBA"]]]]
    ]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore], new_book, :before, true)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_first_node_before_list"))
    assert content == xml
  end
  test "Create a node on second node (list-before)" do
    {:ok,{_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    new_author = [
      [Author: [attrs: [chapters: "1-5-6"], value: "new one"]],
      [Author: [attrs: [chapters: "2-5-7"], value: "Stephan"]]
    ]
    {xml, content} =
      XKX.create_node(xml, [:Bookstore, :Book], new_author, :before, true)
      |> XKX.convert_K2X
      |> TestHelper.normalize(TestHelper.get_match("create_on_second_node_before_list"))
      assert content == xml
  end
end
