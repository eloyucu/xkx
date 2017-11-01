defmodule XKNodesCreator do
  def create_node(xml, [head | []], new_value, order, is_list, index) do
    xml_ = basic_filter_xml(xml[:value], xml)
    cond do
      xml_[head] == nil -> xml
      true ->
        {_, node} = Keyword.get_and_update!(xml_[head], :value, fn(x) ->
          {x, mix_nodes(x, new_value, order, is_list)}
        end)
        ["#{head}": node]
    end
  end
  def create_node(xml, [head | tail], new_value, order, is_list, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data[head] != nil && data[head] != [] -> # This case is used
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = create_node(x, tail, new_value, order, is_list, 0)
          {x, new_node}
        end)
        cond do
          node[head] == nil || (data == node && node[head] != nil) -> create_node(xml, [head | tail], new_value, order, is_list, index+1) # This case is used
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
      # data != nil && data[head] != nil && index<length(data[head]) -> create_node(xml, [head | tail], new_value, index+1) #It seems that never execute this case.
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
  defp mix_nodes(x, new_value, :before, false), do: new_value++x
  defp mix_nodes(x, new_value, :after, false), do: x++new_value

  defp mix_nodes(x, [head | []], :before, true), do: head ++ x
  defp mix_nodes(x, [head | tail], :before, true), do: head ++ mix_nodes(x, tail, :before, true)

  defp mix_nodes(x, [head | []], :after, true), do: x ++ head
  defp mix_nodes(x, [head | tail], :after, true), do: mix_nodes(x, tail, :after, true) ++ head

  defp basic_filter_xml(nil, xml), do: xml
  defp basic_filter_xml(xml, _), do: xml

  defp get_attrs(nil, attrs), do: attrs
  defp get_attrs(attrs, _), do: attrs[:attrs]
end
