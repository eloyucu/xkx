defmodule XKNodesCreate do
  def create_node(nil, _, _, _), do: nil
  def create_node([], _, _, _), do: nil
  def create_node(xml, [], _, _), do: nil
  def create_node(xml, [head | []], new_value, index) do
    try do
      data = xml |> filter_xml(head, index)
      {x, node} = Keyword.get_and_update!(data, head, fn(x) ->
        {x, [attrs: x[:attrs], value: new_value]}
      end)
      {_, data} = Keyword.pop(xml[:value], head, [])
      [attrs: xml[:attrs], value: Keyword.merge(node, data)]
    rescue
      e in KeyError -> nil
      e in FunctionClauseError -> nil
      true -> nil
    end
  end
  def create_node(xml, [head | tail], new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data[head] != nil && data[head] != [] ->
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = create_node(x, tail, new_value, 0)
          {x, new_node}
        end)
        cond do
          node != nil && node[head] != nil -> [attrs: xml[:attrs] ,value: node ]
          true -> create_node(xml, tail, new_value, index+1)
        end
      data != nil && data[head] != nil && index<length(data[head]) -> create_node(xml, [head | tail], new_value, index+1)
      true -> nil
    end
  end
  defp filter_xml(xml, head, index) do
    xml = cond do
      xml[:value] != nil -> xml[:value]
      true -> xml
    end
    cond do
      xml == nil || index>length(xml) || Enum.at(xml, index)==nil -> nil
      true ->
        {_, xml} = xml |> Enum.at(index)
        ["#{head}": xml]
    end
  end
end
