defmodule XKAttributesSetter do
  def set_attribute(x, attr_to_match, new_value) when is_list(new_value) do
    [attrs: new_value, value: x[:value]]
  end
  def set_attribute(x, attr_to_match, new_value) do
    x_ = x[:attrs]
    x_ = Keyword.update(x_, attr_to_match, new_value, fn(y) ->
      new_value
    end)
    [attrs: x_, value: x[:value]] # |> IO.inspect
  end
  def set_attribute(xml, [head | []], attr_to_match, new_value, index)  do
    data = xml |> filter_xml(head, index)
    xml_ = basic_filter_xml(xml[head], xml)
    preserve = Keyword.get_values(data, head) # |> IO.inspect
    try do
      {x, node} = Keyword.get_and_update!(data, head, fn(x) ->
        {x, set_attribute(x, attr_to_match, new_value)}
      end)
      cond do
        xml[:attrs] != nil ->
          {_, node_} = xml_[:value] |> Enum.reduce({0, []}, fn({k, v}, acc) ->
            {i, acc} = acc
            data_ =
            cond do
              ["#{k}": v] != data -> {i+1, acc ++ ["#{k}": v]}
              true -> {i+1, acc ++ node}
            end
          end)
          [attrs: xml[:attrs], value: node_] #|> IO.inspect
        true -> node
      end
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
  # def set_attribute(xml, [head | []], attr_to_match, new_value, index) do
  #   IO.puts ""
  #   IO.puts "set_attribute FINAL head: #{head} index: #{index}"
  #   data = xml |> filter_xml(head, index)
  #   preserve = Keyword.get_values(data, head)
  #   try do
  #     {x, node} = Keyword.get_and_update!(data, head, fn(x) ->
  #       n = set_attribute(x, attr_to_match, new_value) |> IO.inspect
  #       {x, n}
  #     end)
  #     node_ = preserve |> Enum.reduce([], fn(x, acc) ->
  #       cond do
  #         x != data[head] -> acc ++ ["#{head}": x]
  #         true -> acc
  #       end
  #     end)
  #     [attrs: xml[:attrs], value: node ++ node_] # |> IO.inspect
  #   rescue
  #     e in KeyError ->
  #       cond do
  #         data == [] && is_bitstring(xml[:value]) -> nil
  #         true -> xml
  #       end
  #     e in FunctionClauseError -> xml
  #     true -> xml
  #   end
  # end
  def set_attribute(xml, [head | tail], attr_to_match, new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data[head] != nil && data[head] != [] -> # This case is used
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          {x, set_attribute(x, tail, attr_to_match, new_value, 0)}
        end)
        cond do
          (node[head] == nil || (data == node && node[head] != nil)) && index>length(basic_filter_xml(xml, xml[:value])) -> xml # This case is used
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
      xml_ = xml |> Enum.at(index)
      cond do
        xml_ == nil -> xml
        elem(xml_, 0) == head ->
          {head_, xml_} = xml_
          ["#{head}": xml_]
        true -> filter_xml(xml, head, index+1)
      end
  end
  defp basic_filter_xml(nil, xml), do: xml
  defp basic_filter_xml(xml, _), do: xml

  defp get_attrs(nil, attrs), do: attrs
  defp get_attrs(attrs, _), do: attrs[:attrs]

  defp filter_return(nil, xml), do: xml
  defp filter_return(attrs, xml), do: [attrs: attrs, value: xml]

end
