defmodule XKNodesSetterByDependency do
  def set_node_by_dependency(xml, [head | []], new_value, index) do
    data = xml |> filter_xml(head, index)
    preserve = Keyword.get_values(data, head)
    try do
      {x, node} = Keyword.get_and_update!(data, head, fn(x) ->
        {x, [attrs: x[:attrs], value: set_value(new_value[x[:value] |> String.to_atom], x[:value])]}
      end)
      node_ = preserve |> Enum.reduce([], fn(x, acc) ->
        cond do
          x != data[head] -> acc ++ ["#{head}": x]
          true -> acc
        end
      end)
      [attrs: xml[:attrs], value: node ++ node_]
    rescue
      e in KeyError ->
        cond do
          data == [] && is_bitstring(xml[:value]) -> nil
          true -> xml
        end
      e in FunctionClauseError -> xml
      true -> xml
    end
  end
  def set_node_by_dependency(xml, [head | tail], new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data[head] != nil && data[head] != [] -> # This case is used
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = set_node_by_dependency(x, tail, new_value, 0)
          {x, new_node}
        end)
        cond do
          node[head] == nil || (data == node && node[head] != nil) -> set_node_by_dependency(xml, [head | tail], new_value, index+1) # This case is used
          true -> # This case is used
            attrs = get_attrs(xml[head], xml[:attrs])
            xml_ = basic_filter_xml(xml[:value], xml)
            preserve = Keyword.get_values(xml_, head)
            preserve |> Enum.reduce([], fn(x, acc) ->
              cond do
                x != data[head] -> acc ++ ["#{head}": x]
                node[head] != nil && node[head][:value] != nil -> acc ++ ["#{head}": node[head]]
                node[head] != nil  -> acc ++ ["#{head}": [attrs: attrs, value: node[head]]]
                true -> acc ++ [attrs: attrs, value: node]
              end
            end)
        end
      # data != nil && data[head] != nil && index<length(data[head]) -> set_node_by_dependency(xml, [head | tail], new_value, index+1) #It seems that never execute this case.
      true -> xml # This case is used
    end
  end

  defp filter_xml(xml, head, index) do
    xml = basic_filter_xml(xml[:value], xml)
    cond do
      xml |> is_bitstring -> []
      xml == nil || index>length(xml) || Enum.at(xml, index)==nil -> []
    #   xml[head] == nil -> []
      true ->
        {head_, xml_} = xml |> Enum.at(index)
        cond do
          head_ == head -> ["#{head}": xml_]
          true -> xml
        end
    end
  end
  defp basic_filter_xml(nil, xml), do: xml
  defp basic_filter_xml(xml, _), do: xml

  defp get_attrs(nil, attrs), do: attrs
  defp get_attrs(attrs, _), do: attrs[:attrs]

  defp set_value(nil, old_value), do: old_value
  defp set_value(new_value, old_value), do: new_value
end
