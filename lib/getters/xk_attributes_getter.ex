defmodule XKAttributesGetter do

  def get_node_attrs(nil, path, _), do: nil
  def get_node_attrs(xml, [head | []], _), do: xml[:attrs][head]
  def get_node_attrs(xml, [head | tail], _) when length(tail)==1 do
    [tail] = tail
    cond do
      xml[:value][head][:attrs][tail] != nil -> xml[:value][head][:attrs][tail]
      xml[head][:attrs][tail] != nil -> xml[head][:attrs][tail]
      true ->
        attr =
          Enum.filter(xml[:value], fn(x)->
            if elem(x, 1)[:attrs][tail] != nil, do: true
          end)
        attr[head][:attrs][tail]
    end
  end
  def get_node_attrs(xml, [head | tail], index) do
    cond do
      xml |> Keyword.get(:value) != nil && index<length(xml |> Keyword.get(:value)) ->
        get_node_attrs_aux(xml, [head | tail], index)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && index<length(xml[head] |> Keyword.get(:value)) ->
        get_node_attrs_aux(xml, [head | tail], index)
      true -> nil
    end
  end
  defp get_node_attrs_aux(xml, [head | tail], index) do
    xml = cond do
      xml[head] != nil -> [value: xml]
      true -> xml
    end
    node = Enum.at(xml |> Keyword.get(:value), index)
    cond do
      elem(node,0) == head ->
        node = node |> elem(1) |> Keyword.get(:value) |> get_node_attrs(tail, 0)
        cond do
          node == nil -> get_node_attrs(xml, [head | tail], index+1)
          true -> node
        end
      true -> get_node_attrs(xml, [head | tail], index+1)
    end
  end
end
