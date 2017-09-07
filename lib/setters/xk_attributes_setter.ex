defmodule XKAttributesSetter do
  # def set_attribute(nil, _, _, _, _), do: []
  # def set_attribute([], _, _, _, _), do: []
  # def set_attribute(xml, [], _, _, _), do: xml
  # def set_attribute(xml, [head | []], _, _, _) when is_bitstring(xml), do: xml
  def set_attribute({k, v, acc}, {attr_to_match, new_value}, {true, x}) when not is_nil(x) do
    {_, v} = v |> Keyword.get_and_update!(:attrs, fn(x)->
      {nil, Keyword.merge(v[:attrs], ["#{attr_to_match}": new_value])}
    end)
    acc ++ ["#{k}": v]
  end
  def set_attribute({k, v, acc}, _, _), do: acc ++ ["#{k}": v]

  def set_attribute(xml, [head | []], attr_to_match, new_value, index) do
    xml_ = xml[:value] |> basic_filter_xml(xml) |> Enum.reduce([], fn({k, v}, acc) ->
      set_attribute({k, v, acc}, {attr_to_match, new_value}, {k==head, v[:attrs][attr_to_match]})
    end)
    filter_return(xml[:attrs], xml_)
  end
  def set_attribute(xml, [head | tail], attr_to_match, new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data[head] != nil && data[head] != [] -> # This case is used
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = set_attribute(x, tail, new_value, attr_to_match, 0)
          {x, new_node}
        end)
        cond do
          node[head] == nil || (data == node && node[head] != nil) -> set_attribute(xml, [head | tail], attr_to_match, new_value, index+1) # This case is used
          true -> # This case is used
            attrs = get_attrs(xml[head], xml[:attrs])
            basic_filter_xml(xml[:value], xml)
            |> Enum.reduce([], fn({k, v}, acc) ->
              cond do
                v != data[head] -> acc ++ ["#{k}": v]
                node[head] != nil && node[head][:value] != nil -> acc ++ ["#{head}": node[head]]
                node[head] != nil  -> acc ++ ["#{head}": [attrs: attrs, value: node[head]]]
                true -> acc ++ [attrs: attrs, value: node]
              end
            end)
        end
      # data != nil && data[head] != nil && index<length(data[head]) -> set_attribute(xml, [head | tail], attr_to_match, new_value, index+1) #It seems that never execute this case.
      true -> xml # This case is used
    end
  end
  defp filter_xml(xml, head, index) do
    xml = basic_filter_xml(xml[:value], xml)
    # cond do
    #   xml |> is_bitstring -> []
    #   xml == nil || index>length(xml) || Enum.at(xml, index)==nil -> []
    #   xml[head] == nil -> []
    #   true ->
        {head_, xml_} = xml |> Enum.at(index)
        cond do
          head_ == head -> ["#{head}": xml_]
          true -> xml
        end
    # end
  end
  defp basic_filter_xml(nil, xml), do: xml
  defp basic_filter_xml(xml, _), do: xml

  defp get_attrs(nil, attrs), do: attrs
  defp get_attrs(attrs, _), do: attrs[:attrs]

  defp filter_return(nil, xml), do: xml
  defp filter_return(attrs, xml), do: [attrs: attrs, value: xml]

end
