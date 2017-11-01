defmodule XKNodesMultipleSetterByDependency do
  def set_node_multiple_by_dependency(xml, [head | []], new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data == [] && is_bitstring(xml[:value]) -> nil
      data == [] -> xml
      true ->
        data |> Enum.reduce([], fn({x, y}, acc) ->
          cond do
            x == head -> acc ++ ["#{head}": [attrs: y[:attrs], value: set_value(new_value[y[:value] |> String.to_atom], y[:value])]]
            true -> acc ++ ["#{x}": [attrs: y[:attrs], value: y[:value]]]
          end
        end)
    end
  end
  def set_node_multiple_by_dependency(xml, [head | tail], new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data != nil && data[head] != nil && data[head] != [] -> # This case is used
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = set_node_multiple_by_dependency(x, tail, new_value, 0)
          {x, new_node}
        end)
        cond do
          node[head] == nil || (data == node && node[head] != nil) -> set_node_multiple_by_dependency(xml, [head | tail], new_value, index+1) # This case is used
          true -> # This case is used
            attrs = get_attrs(xml[head], data[head], xml)
            basic_filter_xml(xml[:value], xml)
            |> Keyword.get_values(head)
            |> Enum.reduce([], fn(x, acc) ->
              cond do
                x != data[head] -> acc ++ ["#{head}": x]
                node[head] != nil -> acc ++ ["#{head}": [attrs: attrs, value: node[head]]]
                true -> acc ++ [attrs: attrs, value: node]
              end
            end)
        end
      # data != nil && data[head] != nil && index<length(data[head]) -> set_node_multiple_by_dependency(xml, [head | tail], new_value, index+1) # It seems that this case is never executed.
      true -> xml # This case is used
    end
  end

  def set_node_multiple_all_by_dependency(xml, [head | []], new_value, index) do
    basic_filter_xml(xml[:value], xml) |> Enum.reduce([], fn({x, y}, acc) ->
      cond do
        x == head -> acc ++ ["#{head}": [attrs: y[:attrs], value: set_value(new_value[y[:value] |> String.to_atom], y[:value])]]
        true -> acc ++ ["#{x}": [attrs: y[:attrs], value: y[:value]]]
      end
    end)
  end
  def set_node_multiple_all_by_dependency(xml, [head | tail], new_value, index) do
    xml = basic_filter_xml(xml[:value], xml)
    cond do
      index<length(xml) && xml[head]!=nil ->
        xml |> Enum.reduce([], fn({k, v}, acc) ->
          x = ["#{k}": v]
          attrs = x[head][:attrs]
          {_, node} =
          cond do
            x[head] != nil ->
              Keyword.get_and_update!(x, head, fn(y) ->
                new_node = set_node_multiple_all_by_dependency(y, tail, new_value, 0)
                {y, new_node}
              end)
            true -> {:ok, x}
          end
          cond do
            node[head] != nil && node[head][:value] != nil -> acc ++ ["#{head}": node[head]]
            node[head] != nil  -> acc ++ ["#{head}": [attrs: attrs, value: node[head]]]
            true -> acc ++ node
          end

        end)
      xml[head]==nil -> xml
      # true -> set_node_multiple_all_by_dependency(xml, [head | tail], new_value, index+1)
    end
  end

  defp filter_xml(xml, head, index) do
    xml = basic_filter_xml(xml[:value], xml)
    cond do
      # xml |> is_bitstring -> []
      # xml == nil || index>length(xml) || Enum.at(xml, index)==nil -> []
      xml[head] == nil -> []
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

  defp get_attrs(attrs, _, _) when not is_nil(attrs), do: attrs[:attrs]
  defp get_attrs(_, attrs, _) when not is_nil(attrs), do: attrs[:attrs]
  defp get_attrs(_, _, attrs), do: attrs[:attrs]


  defp set_value(nil, old_value), do: old_value
  defp set_value(new_value, old_value), do: new_value
end
