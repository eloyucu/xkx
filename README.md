# XKX

## Description
XKX is a xml parser that transform a xml into a keyword elixir structure (using `convert_X2K`), and build a xml from a keyword structure (using `convert_K2X`).
XKX provides too a list of functions to handle or modify this parsed xml. Using XKX you have an easy way to get or set the value of any node or attribute.

## How to use
### convert_X2K and convert_K2X
To parse the xml is as easier as to use the `XKX.convert_X2K(xml)` function. In this way, we can get this result:
```
{:ok, {:father,
  [
    father:
    [
      attrs:[],
      value:
      [
        foo:
        [
          attrs:[attr: "wadus"],
          value: "bar"
        ]
      ]
    ]
  ]}
}
```
from this xml:
```
<father>
  <foo attr="wadus">
    bar
  </foo>
</father>
```

The first element of tuple is *:ok* if everything goes right, or *:error* if something fails. The second element is the name of the top level node. The third one is just the data structure.
The errors we can obtain are:
`{:error, nil, "Empty XML message"}`
`{:error, nil, "Fatal error parsing XML message"}`

For the opposite operation we use `convert_K2X(data)` (data should be a structure similar as the third element of the tuple), and we obtain the xml from the keyword.
Another important functions are:
### get_node_value
To get the value of a node passing as second param the "path" to this node. Example (using the xml above):
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
value = XKX.get_node_value(data, [:father, :foo])
```
value will be _foo_
### get_node
The difference between this function and the previous is that this one gets all the structure of the node. Example
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
value = XKX.get_node(data, [:father, :foo])
```
value will:
_[
  attrs:[attr: "wadus"],
  value: "bar"
]_

### get_node_value_list
So far, we were getting the first value found in the xml that match with the path... but it is obvius that in a xml we can find more than one occurrence of a node "following" a determined path. This function will return a list of values of all nodes found in the param path. Example (using this new xml):
```
<Bookstore id="BOOKSTORE">
  <Booking id='0' class='terror booking'>
    <ISBN type='international'>ISBN_booking</ISBN>
    <Name>The Booking Letcture</Name>
    <Author>Randy Pausch</Author>
  </Booking>
  <Book id='1' class='terror'>
    <ISBN type='international'>ISBN_1</ISBN>
    <Name>The Last Letcture</Name>
    <Author>Randy Pausch</Author>
  </Book>
  <Book id='2' class='sci-fic' seller='second'>
    <ISBN type='national'>ISBN_2</ISBN>
    <Name>The Cool Letcture</Name>
    <Author>Randy Orton</Author>
    <Unique valid='true'>true</Unique>
  </Book>
  <Book id='3' class='comedy' seller='best'>
    <ISBN type='EU'>
      <special>ISBN_3</special>
    </ISBN>
    <Name>The Legend</Name>
    <Author>Mike San Francisco</Author>
  </Book>
</Bookstore>
```
The invoking of the function:
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
value = XKX.get_node_value_list(data, [:Bookstore, :Book, :ISBN])
```
And the result will be:
_[
  [special: [attrs: [], value: "ISBN_3"]],
  "ISBN_2",
  "ISBN_1"
]_

### get_node_list
The difference between this function and the previous is similar at difference between `get_node_value` and `get_node`. Example:
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
value = XKX.get_node_list(data, [:Bookstore, :Book, :ISBN])
```
The result is:
_[
  [attrs: [type: "EU"], value: [special: [attrs: [], value: "ISBN_3"]]],
  [attrs: [type: "national"], value: "ISBN_2"],
  [attrs: [type: "international"], value: "ISBN_1"]
]_

### get_node_attrs
With this fuction, we can obtain a determined attribute (indicated by the third param) of a node. Example:
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
value = val = XKX.get_node_attrs(data, [:Bookstore, :Book], :seller)
```
And the result will be _second_

### set_node
This function will set the first occurrence of a node with a new value passed as the third argument of the function. Example:
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
xml =
  XKX.set_node(data, [:Bookstore, :Booking, :Other], "wally")
  |> XKX.convert_K2X
```
You can find the xml result with the modified node here: https://github.com/eloyucu/xkx/blob/master/test/xmls/match/content_set_first_occurrence.xml

### set_node_multiple
We can have the needed about modify all the ocurrences of a node in a path... but only the first occurrence of the father. Example (using this xml https://github.com/eloyucu/xkx/blob/master/test/xmls/short_content.xml):
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
xml =
  XKX.set_node_multiple(data, [:Bookstore, :Booking, :Other], "wally")
  |> XKX.convert_K2X
```
And the result will be: https://github.com/eloyucu/xkx/blob/master/test/xmls/match/short_content_multiply_other.xml


### set_node_multiple_all
Modifies all ocurrences of a node in the xpath. We are going to use the same xml and xpath than before, in this way, differences between these two similar functions will be easier to see.
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
xml =
  XKX.set_node_multiple_all(data, [:Bookstore, :Booking, :Other], "wally")
  |> XKX.convert_K2X
```
And the result will be: https://github.com/eloyucu/xkx/blob/master/test/xmls/match/short_content_multiply_other_all.xml.xml

### set_node_attr
Two ways to use this function:
1) set_node_attr(xml, nodes, attr, new_value) -> the third argument is the attribute to change the value, and the fourth is the new value.
2) set_node_attr(xml, nodes, attrs) -> the third argument is a keyword list that will be setted as attributes for the last element of the path (on nodes param).
In this way we can use:
`XKX.set_node_attr(xml, [:Bookstore], :id, "wally")`
or alternatively use:
`XKX.set_node_attr(xml, [:Bookstore], [id: "wally"])`
The advantage of the second way is that we can set more than one attr with only one invoking to this function:
`XKX.set_node_attr(xml, [:Bookstore], [id: "wally", foo: "bar", other_attr: "value"])`

### set_attribute_multiple and set_attribute_multiple_all
These tow functions make the same than _set_node_multiple_ and _set_node_multiple_all_ respectively, but modifying the attributes instead of the nodes.
### create_node
There are 4 ways to interact with this function based on the last two arguments.
The signature for this function is `create_node(data, path, new_value, order, is_list)` where data, path and new_value are easy know what they do. Order argument indicates to function if the new_value should be _:after_ or _:before_ that the preexisting list of nodes. On the other hand, is_list indicates if the new_value argument is a list of new nodes (_true_) or a simple node (_false_). A list of quick examples about how call this function:
```
XKX.create_node(data, [:root, :son], node, :after, false)
XKX.create_node(data, [:root, :son], [node, node], :after, true)
XKX.create_node(data, [:root, :son], node, :before, false)
XKX.create_node(data, [:root, :son], [node, node], :before, true)
```
### set_node_by_dependency
This function allows to set a node with a new value but pasing a keyword and set this new value deppending on the old value. Something like (using the simplest xml on the top of this document):
```
{:ok, {_, data}} = XKX.convert_X2K(xml)
value = XKX.set_node_by_dependency(data, [:father, :foo], [bar: "ok", other: "no", other_one: "neither"])
```
And the result will be:
```
<father>
  <foo attr="wadus">
    ok
  </foo>
</father>
```
### set_node_multiple_by_dependency and set_node_multiple_by_dependency_all
Here the differences are similar than the other functinality for set the value of single node and a list of nodes.  
Please check this test (and its resulting xml) https://github.com/eloyucu/xkx/blob/master/test/xk_set_node_dependency_test.exs
