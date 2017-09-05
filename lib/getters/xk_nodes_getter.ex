defmodule XKNodesGetter do
  def get_node_value(nil, path, _), do: nil
  def get_node_value(xml, [], _), do: xml[:value]
  def get_node_value(xml, [head | []], _) do
    cond do
      is_binary(xml) || is_binary(xml |> Keyword.get(:value)) -> nil
      xml[head] != nil -> xml[head][:value]
      true -> xml[:value][head][:value]
    end
  end
  def get_node_value(xml, [head | tail], index) do
    cond do
      xml |> Keyword.get(:value) != nil && is_binary(xml |> Keyword.get(:value)) ->
        get_node_value(xml, tail, index)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && is_binary(xml[head] |> Keyword.get(:value)) ->
        get_node_value(xml[head], tail, index)
      xml |> Keyword.get(:value) != nil && index<length(xml |> Keyword.get(:value)) ->
        get_node_value_aux(xml, [head | tail], index)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && index<length(xml[head] |> Keyword.get(:value)) ->
        get_node_value_aux(xml, [head | tail], index)
      true -> nil
    end
  end
  def get_node_value(xml, head, _), do: xml[head][:value]
  def get_node_value_aux(xml, [head | tail], index) do
    xml = cond do
      xml[head] != nil -> [value: xml]
      true -> xml
    end
    node = Enum.at(xml |> Keyword.get(:value), index)
    cond do
      elem(node,0) == head && is_bitstring((elem(node, 1) |> Keyword.get(:value))) ->
        elem(node, 1) |> Keyword.get(:value)
      elem(node,0) == head ->
        node = node |>
        elem(1) |>
        Keyword.get(:value) |>
        get_node_value(tail, 0)
        cond do
          node == nil -> get_node_value(xml, [head | tail], index+1)
          true -> node
        end
      true -> get_node_value(xml, [head | tail], index+1)
    end
  end


  def get_node(nil, path, _), do: nil
  def get_node(xml, [], _), do: xml
  def get_node(xml, [head | []], _) do
    cond do
      is_binary(xml) || is_binary(xml |> Keyword.get(:value)) -> nil
      xml[head] != nil -> xml[head]
      xml[:value] != nil -> xml[:value][head]
      true -> nil
    end
  end
  def get_node(xml, [head | tail], index) do
    cond do
      xml |> Keyword.get(:value) != nil && is_bitstring(xml |> Keyword.get(:value)) ->
        get_node(xml, tail, index)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && is_bitstring(xml[head] |> Keyword.get(:value)) ->
        get_node(xml[head], tail, index)
      xml |> Keyword.get(:value) != nil && index<length(xml |> Keyword.get(:value)) ->
        get_node_aux(xml, [head | tail], index)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && index<length(xml[head] |> Keyword.get(:value)) ->
        get_node_aux(xml, [head | tail], index)
      true -> nil
    end
  end
  def get_node_aux(xml, [head | tail], index) do
    xml = cond do
      xml[head] != nil -> [value: xml]
      true -> xml
    end
    node = Enum.at(xml |> Keyword.get(:value), index)
    cond do
      elem(node,0) == head ->
        node = node |> elem(1) |> Keyword.get(:value) |> get_node(tail, 0)
        cond do
          node == nil -> get_node(xml, [head | tail], index+1)
          true -> node
        end
      true -> get_node(xml, [head | tail], index+1)
    end
  end
end
