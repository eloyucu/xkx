defmodule XKX do
  @moduledoc """
  Documentation for XKX.
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
  get_node_attrs
  """
  def get_node_attrs(xml, [head | tail], attr), do: XKAttributesGetter.get_node_attrs(xml[head], tail ++ [attr], 0)
  @doc """
  create_node
  """
  def create_node(xml, [head | tail], new_value, order, is_list), do: XKNodesCreator.create_node(xml, [head | tail], new_value, order, is_list, 0)
  @doc """
  set_node
  """
  def set_node(xml, [head | tail], new_value), do: XKNodesSetter.set_node(xml, [head | tail], new_value, 0)
  @doc """
  set_node_by_dependency
  """
  def set_node_by_dependency(xml, [head | tail], new_value), do: XKNodesSetterByDependency.set_node_by_dependency(xml, [head | tail], new_value, 0)
  @doc """
  set_node_multiple
  """
  def set_node_multiple(xml, [head | tail], new_value), do: XKNodesMultipleSetter.set_node_multiple(xml, [head | tail], new_value, 0)
  @doc """
  set_node_multiple_all
  """
  def set_node_multiple_all(xml, [head | tail], new_value), do: XKNodesMultipleSetter.set_node_multiple_all(xml, [head | tail], new_value, 0)
  @doc """
  set_node_multiple_by_dependency
  """
  def set_node_multiple_by_dependency(xml, [head | tail], new_value), do: XKNodesMultipleSetterByDependency.set_node_multiple_by_dependency(xml, [head | tail], new_value, 0)
  @doc """
  set_node_multiple_all_by_dependency
  """
  def set_node_multiple_all_by_dependency(xml, [head | tail], new_value), do: XKNodesMultipleSetterByDependency.set_node_multiple_all_by_dependency(xml, [head | tail], new_value, 0)
  @doc """
  set_node_attr
  """
  def set_node_attr(xml, nodes, attr, new_value), do: XKAttributesSetter.set_attribute(xml, nodes, attr, new_value, 0) |> filter_output
  def set_node_attr(xml, nodes, new_value), do: XKAttributesSetter.set_attribute(xml, nodes, nil, new_value, 0) |> filter_output
  @doc """
  set_node_attr_multiple
  """
  def set_attribute_multiple(xml, nodes, attr, new_value), do: XKAttributesMultipleSetter.set_attribute_multiple(xml, nodes, attr, new_value, 0) |> filter_output
  def set_attribute_multiple(xml, nodes, new_value), do: XKAttributesMultipleSetter.set_attribute_multiple(xml, nodes, nil, new_value, 0) |> filter_output
  @doc """
  set_node_attr_multiple_all
  """
  def set_attribute_multiple_all(xml, nodes, attr, new_value), do: XKAttributesMultipleSetter.set_attribute_multiple_all(xml, nodes, attr, new_value, 0) |> filter_output
  def set_attribute_multiple_all(xml, nodes, new_value), do: XKAttributesMultipleSetter.set_attribute_multiple_all(xml, nodes, nil, new_value, 0) |> filter_output



  defp filter_output(data) do
    cond do
      data[:value] != nil -> data[:value]
      true -> data
    end
  end
end
