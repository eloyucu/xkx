defmodule XK do
  @moduledoc """
  Documentation for XK.
  """

  @doc """
  convert_X2K
  """
  def convert_X2K(xml), do: XKConvertX2K.convert_X2K(xml)
  @doc """
  convert_K2X
  """
  def convert_K2X(xml, namespace_list \\ [], actual_namespace \\ "", level \\ 0), do: XKConvertK2X.convert_K2X(xml, namespace_list, actual_namespace, level)
  @doc """
  get_node_value
  """
  def get_node_value(xml, [head | tail]), do: XKNodesGetter.get_node_value(xml[head], tail, 0)
  @doc """
  get_node
  """
  def get_node(xml, [head | tail]), do: XKNodesGetter.get_node(xml[head], tail, 0)
  @doc """
  get_get_node_list
  """
  def get_node_list(xml, [head | tail]) when length(tail)==1  do #: XKNodesListGetter.get_node_list(xml, [head | tail], 0, [])
    [tail] = tail
    Enum.reduce(xml[head][:value], [], fn(x, acc) ->
      cond do
        elem(x, 0) == tail -> acc ++ [elem(x, 1)]
        true -> acc
      end
    end)
  end
  def get_node_list(xml, [head | tail]), do: XKNodesListGetter.get_node_list(xml[head], tail, 0, []) |> get_node_list_filter
  defp get_node_list_filter(data), do: data |> Enum.filter(fn(x)-> x != nil end)
  @doc """
  get_get_node_value_list
  """
  def get_node_value_list(xml, [head | tail]) when length(tail)==1  do #: XKNodesListGetter.get_node_list(xml, [head | tail], 0, [])
    [tail] = tail
    Enum.reduce(xml[head][:value], [], fn(x, acc) ->
      cond do
        elem(x, 0) == tail -> acc ++ [(elem(x, 1) |> Keyword.get(:value))]
        true -> acc
      end
    end)
  end
  def get_node_value_list(xml, [head | tail]), do: XKNodesListGetter.get_node_value_list(xml[head], tail, 0, [])
  @doc """
  getAttributesValue
  """
  # def get_node_attrs(xml, [head | tail], nil), do: node = XKNodesGetter.get_node(xml[head], tail, 0)[:attrs]
  # def get_node_attrs(xml, [head | tail], attr), do: node = XKNodesGetter.get_node(xml[head], tail, 0)[:attrs][attr]
  # TODO: move the "attr" as a third parameter in XKAttributesGetter.get_node_attrs and simplify the last function get_node_attrs
  def get_node_attrs(xml, [head | tail], attr), do: XKAttributesGetter.get_node_attrs(xml[head], tail ++ [attr], 0)

  @doc """
  set_node
  """
  def set_node(xml, [head | tail], new_value), do: XKNodesSetter.set_node(xml, [head | tail], new_value, 0)
  @doc """
  set_node
  """
  def set_node_multiple(xml, [head | tail], new_value), do: XKNodesMultipleSetter.set_node_multiple(xml, [head | tail], new_value, 0)
  @doc """
  """
  def set_node_multiple_all(xml, [head | tail], new_value), do: XKNodesMultipleSetter.set_node_multiple_all(xml, [head | tail], new_value, 0)
  @doc """
  create_node
  """
  def create_node(xml, [head | tail], new_value), do: XKNodesCreate.create_node(xml, [head | tail], new_value, 0)
  @doc """
  create_node
  """
  def set_node_attr(xml, [head | tail], attr, new_value), do: XKAttributesSetter.set_attribute(xml, [head | tail], attr, new_value, 0)
end
