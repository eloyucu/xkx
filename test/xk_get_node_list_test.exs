defmodule XKNodesListGetterTest do
  use ExUnit.Case
  doctest XKX

  test "Get all sons of a node first Element" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_list(xml, [:Bookstore])
    assert val ==
    [
      [
        attrs: [id: "BOOKSTORE"],
        value: [
          Booking: [
            attrs: [id: "0", class: "terror booking"],
            value: [
              ISBN: [attrs: [type: "international"], value: "ISBN_booking"],
              Name: [attrs: [], value: "The Booking Letcture"],
              Author: [attrs: [], value: "Randy Pausch"]
            ]
          ],
          Book: [
            attrs: [id: "1", class: "terror"],
            value: [
              ISBN: [attrs: [type: "international"], value: "ISBN_1"],
              Name: [attrs: [], value: "The Last Letcture"],
              Author: [attrs: [], value: "Randy Pausch"]
            ]
          ],
          Book: [
            attrs: [id: "2", class: "sci-fic", seller: "second"],
            value: [
              ISBN: [attrs: [type: "national"], value: "ISBN_2"],
              Name: [attrs: [], value: "The Cool Letcture"],
              Author: [attrs: [], value: "Randy Orton"],
              Unique: [attrs: [valid: "true"], value: "true"]
            ]
          ],
          Book: [
            attrs: [id: "3", class: "comedy", seller: "best"],
            value: [
              ISBN: [attrs: [type: "EU"], value: [special: [attrs: [], value: "ISBN_3"]]],
              Name: [attrs: [], value: "The Legend"],
              Author: [attrs: [], value: "Mike San Francisco"]
            ]
          ]
        ]
      ]
    ]
  end
  test "Get all sons of a node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_list(xml, [:Bookstore, :Book])
    assert val == [
      [
        attrs: [id: "1", class: "terror"],
        value: [
          ISBN: [attrs: [type: "international"], value: "ISBN_1"],
          Name: [attrs: [], value: "The Last Letcture"],
          Author: [attrs: [], value: "Randy Pausch"]
        ]
      ],
      [
        attrs: [id: "2", class: "sci-fic", seller: "second"],
        value: [
          ISBN: [attrs: [type: "national"], value: "ISBN_2"],
          Name: [attrs: [], value: "The Cool Letcture"],
          Author: [attrs: [], value: "Randy Orton"],
          Unique: [attrs: [valid: "true"], value: "true"]
        ]
      ],
      [
        attrs: [id: "3", class: "comedy", seller: "best"],
        value: [
          ISBN: [attrs: [type: "EU"], value: [special: [attrs: [], value: "ISBN_3"]]],
          Name: [attrs: [], value: "The Legend"],
          Author: [attrs: [], value: "Mike San Francisco"]
        ]
      ]
    ]
  end
  test "Get all sons of a node (deeper)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_list(xml, [:Bookstore, :Book, :ISBN])
    assert val == [
      [attrs: [type: "EU"], value: [special: [attrs: [], value: "ISBN_3"]]],
      [attrs: [type: "national"], value: "ISBN_2"],
      [attrs: [type: "international"], value: "ISBN_1"]
    ]
  end
  test "Get all sons of a node (deepest)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_list(xml, [:Bookstore, :Book, :ISBN, :special])
    assert val == [[attrs: [], value: "ISBN_3"]]
  end
  test "Get a list of values of some nodes" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_value_list(xml, [:Bookstore, :Book, :ISBN])
    assert val == [[special: [attrs: [], value: "ISBN_3"]], "ISBN_2", "ISBN_1"]
  end
  test "Get the list of values of the deepest node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    name = XKX.get_node_value_list(xml, [:Bookstore, :Book, :Author, :Name])
    special = XKX.get_node_value_list(xml, [:Bookstore, :Book, :Author, :Name, :Given, :ISBN, :special])
    assert name == [[Given: [attrs: [], value: [ISBN: [attrs: [type: "EU"], value: [special: [attrs: [attr: "value"], value: "ISBN_3"]]]]]]]
    assert special == ["ISBN_3"]
  end
  test "Get the list of structures of the deepest node" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_deep_content())
    name = XKX.get_node_list(xml, [:Bookstore, :Book, :Author, :Name])
    given = XKX.get_node_list(xml, [:Bookstore, :Book, :Author, :Name, :Given])
    special = XKX.get_node_list(xml, [:Bookstore, :Book, :Author, :Name, :Given, :ISBN, :special])
    assert name == [[attrs: [], value: [Given: [attrs: [], value: [ISBN: [attrs: [type: "EU"], value: [special: [attrs: [attr: "value"], value: "ISBN_3"]]]]]]]]
    assert given ==  [[attrs: [], value: [ISBN: [attrs: [type: "EU"], value: [special: [attrs: [attr: "value"], value: "ISBN_3"]]]]]]
    assert special == [[attrs: [attr: "value"], value: "ISBN_3"]]
  end
  test "Get a list of values of some nodes (deepest)" do
    {:ok, {_, xml}} = XKX.convert_X2K(TestHelper.get_content())
    val = XKX.get_node_value_list(xml, [:Bookstore, :Book, :ISBN, :special])
    assert val == ["ISBN_3"]
  end
end
