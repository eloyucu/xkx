defmodule XKNodesListRemover do
  def remove_node_list(nil, _, _, _), do: []
  def remove_node_list([], _, _, _), do: []
  def remove_node_list(xml, [], _, _), do: xml
  def remove_node_list(xml, [head | []], _, _) when is_bitstring(xml), do: xml
  def remove_node_list(xml, [head | []], new_value, index) do
    data = xml |> filter_xml(head, index)
    IO.puts ""
    IO.puts "remove_node_list index: #{index} HEAD: #{head}"
    IO.puts "XML VALUE"
    IO.inspect xml
    IO.puts "DATA VALUE"
    IO.inspect data
    cond do
      data == [] && is_bitstring(xml[:value]) -> nil
      data == [] -> xml
      true ->
        IO.puts "PRESERVE VALUE"
        preserve = Keyword.get_values(data, head) |> IO.inspect
        IO.puts "POPPED VALUE"
        {_, popped} = data |> Keyword.pop(head)
        IO.inspect popped
        # Enum.reduce(preserve, popped, fun({}, acc) ->
        #   acc ++ ["#{head}": [attrs: x[:attrs], value: new_value]]
        # end)
    end
  end
  def remove_node_list(xml, [head | tail], new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data != nil && data[head] != nil && data[head] != [] -> # This case is used
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = remove_node_list(x, tail, new_value, 0)
          {x, new_node}
        end)
        cond do
          node[head] == nil || (data == node && node[head] != nil) -> remove_node_list(xml, [head | tail], new_value, index+1) # This case is used
          true -> # This case is used
            attrs = cond do
              xml[head] != nil -> xml[head][:attrs]
              true -> xml[:attrs]
            end
            xml_ = basic_filter_xml(xml)
            preserve = Keyword.get_values(xml_, head)
            preserve |> Enum.reduce([], fn(x, acc) ->
              cond do
                x != data[head] -> acc ++ ["#{head}": x]
                node[head] != nil -> acc ++ ["#{head}": [attrs: attrs, value: node[head]]]
                true -> acc ++ [attrs: attrs, value: node]
              end
            end)
        end
      data != nil && data[head] != nil && index<length(data[head]) -> remove_node_list(xml, [head | tail], new_value, index+1) #It seems that never execute this case.
      true -> xml # This case is used
    end
  end
  defp filter_xml(xml, head, index) do
    xml = basic_filter_xml(xml)
    cond do
      xml |> is_bitstring -> []
      xml == nil || index>length(xml) || Enum.at(xml, index)==nil -> []
      xml[head] == nil -> []
      true ->
        {head_, xml_} = xml |> Enum.at(index)
        cond do
          head_ == head -> ["#{head}": xml_]
          true -> xml
        end
    end
  end
  defp basic_filter_xml(xml) do
    cond do
      xml[:value] != nil -> xml[:value]
      true -> xml
    end
  end
end
