defmodule XKConvertTest do
  use ExUnit.Case
  doctest XK


  test "Convert from text" do
    xml = XK.convert_X2K(TestHelper.get_content())
    assert xml == {:ok, {:Bookstore,
      [Bookstore: [attrs: [id: "BOOKSTORE"],
        value: [Booking: [attrs: [id: "0", class: "terror booking"],
          value: [ISBN: [attrs: [type: "international"], value: "ISBN_booking"],
           Name: [attrs: [], value: "The Booking Letcture"],
           Author: [attrs: [], value: "Randy Pausch"]]],
         Book: [attrs: [id: "1", class: "terror"],
          value: [ISBN: [attrs: [type: "international"], value: "ISBN_1"],
           Name: [attrs: [], value: "The Last Letcture"],
           Author: [attrs: [], value: "Randy Pausch"]]],
         Book: [attrs: [id: "2", class: "sci-fic", seller: "second"],
          value: [ISBN: [attrs: [type: "national"], value: "ISBN_2"],
           Name: [attrs: [], value: "The Cool Letcture"],
           Author: [attrs: [], value: "Randy Orton"],
           Unique: [attrs: [valid: "true"], value: "true"]]],
         Book: [attrs: [id: "3", class: "comedy", seller: "best"],
          value: [ISBN: [attrs: [type: "EU"],
            value: [special: [attrs: [], value: "ISBN_3"]]],
           Name: [attrs: [], value: "The Legend"],
           Author: [attrs: [], value: "Mike San Francisco"]]]]]]}}
  end
  test "Convert from text deep" do
    xml = XK.convert_X2K(TestHelper.get_deep_content())
    assert xml == {:ok, {:Bookstore,
      [Bookstore: [attrs: [],
        value: [Book: [attrs: [id: "3", class: "comedy", seller: "best"],
          value: [Author: [attrs: [], value: [Other: [attrs: [], value: []]]],
           Author: [attrs: [],
            value: [Name: [attrs: [],
              value: [Given: [attrs: [],
                value: [ISBN: [attrs: [type: "EU"],
                  value: [special: [attrs: [attr: "value"],
                    value: "ISBN_3"]]]]]]]]]]]]]]}}
  end
  test "Convert from text and after convert_X2K to xml again" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    xml = XK.convert_K2X(xml)
    {xml, content} = TestHelper.normalize(xml, TestHelper.get_content())
    assert xml == content
  end
  test "Convert from text and after convert_X2K to xml again using namespaces" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_content())
    xml = XK.convert_K2X(xml, [Book: "n:", ISBN: ""])
    {xml, content} = TestHelper.normalize(xml, TestHelper.get_match("content_with_namespaces"))
    assert xml == content
  end
  test "Convert from deep text and after convert_X2K to xml again" do
    {:ok, {_, xml}} = XK.convert_X2K(TestHelper.get_deep_content())
    xml = XK.convert_K2X(xml)
    {xml, content} = TestHelper.normalize(xml, TestHelper.get_deep_content())
    assert xml == content
  end
  test "Convert from keymap structure I" do
    data = [Bookstore: [attrs: [blop: "blup"],
      value: [Booking: [attrs: [id: "0", class: "terror booking"],
        value: [International: [attrs: [attr: "I_0"], value: []]]],
       Booking: [attrs: [id: "1", class: "terror booking"],
        value: [International: [attrs: [attr: "I_1"],
          value: [ISBN: [attrs: [type: "international"], value: "ISBN_booking"],
           Name: [attrs: [], value: "The Booking Letcture"],
           Author: [attrs: [], value: "Randy Pausch"]]],
         Other: [attrs: [],
          value: [Final: [attrs: [], value: [Foo: [attrs: [], value: "BAR"]]]]],
         Other: [attrs: [], value: "something_2"],
         Other: [attrs: [], value: "something_3"]]],
       Booking: [attrs: [id: "2", class: "The_third"],
        value: [International: [attrs: [attr: "I_2"], value: []],
         Other: [attrs: [], value: "something other"]]]]]]
     xml = data |> XK.convert_K2X
  end
end
