defmodule XKNodesMultipleSetter do
  def set_node_multiple(nil, _, _, _), do: []
  def set_node_multiple(nil, _, _, _), do: []
  def set_node_multiple([], _, _, _), do: []
  def set_node_multiple(xml, [], _, _), do: xml
  def set_node_multiple(xml, [head | []], _, _) when is_bitstring(xml), do: xml
  def set_node_multiple(xml, [head | []], new_value, index) do
    IO.puts "set_node_multiple FINAL index: #{index} head: #{head} X VALUE"
    IO.inspect xml
    data = xml |> filter_xml(head, index)
    cond do
      data == [] && is_bitstring(xml[:value]) -> nil
      data == [] -> xml
      true ->
        IO.puts "DATA VALUE"
        data |> Enum.reduce([], fn(x, acc) ->
          cond do
            elem(x, 0) == head -> acc ++ ["#{head}": [attrs: elem(x, 1)[:attrs], value: new_value]]
            true -> acc ++ ["#{elem(x, 0)}": [attrs: elem(x, 1)[:attrs], value: elem(x, 1)[:value]]]
          end
        end) |> IO.inspect
    end
  end
  def set_node_multiple(xml, [head | tail], new_value, index) do
    IO.puts ""
    IO.puts "set_node_multiple normal index: #{index} head: #{head}"
    data = xml |> filter_xml(head, index)
    cond do
      data != nil && data[head] != nil && data[head] != [] -> # This case is used
        IO.puts "set_node_multiple normal condo 1.1 index: #{index} head: #{head}"
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = set_node_multiple(x, tail, new_value, 0)
          {x, new_node}
        end)
        IO.puts "NODE VALUE index: #{index} head: #{head}"
        cond do
          node[head] == nil || (data == node && node[head] != nil) ->
            IO.puts "set_node_multiple normal condo 2.1 index: #{index} head: #{head}"
            set_node_multiple(xml, [head | tail], new_value, index+1) # This case is used
          true -> # This case is used
            node |> IO.inspect
            IO.puts ""
            IO.puts "set_node_multiple normal condo 2.2 TRUE index: #{index} head: #{head}"
            IO.puts "XML VALUE index: #{index} head: #{head}"
            xml |> IO.inspect
            IO.puts ""
            attrs = cond do
              xml[head] != nil -> xml[head][:attrs]
              data[head] != nil -> data[head][:attrs]
              true -> xml[:attrs]
            end
            basic_filter_xml(xml)
            |> Keyword.get_values(head)
            |> Enum.reduce([], fn(x, acc) ->
              cond do
                x != data[head] -> acc ++ ["#{head}": x]
                node[head] != nil -> acc ++ ["#{head}": [attrs: attrs, value: node[head]]]
                true -> acc ++ [attrs: attrs, value: node]
              end
            end)
        end
      data != nil && data[head] != nil && index<length(data[head]) ->
        IO.puts "set_node_multiple normal condo 1.2 index: #{index} head: #{head}"
        set_node_multiple(xml, [head | tail], new_value, index+1) # It seems that this case is never executed.
      true ->
        IO.puts "set_node_multiple normal condo 1.3 TRUE index: #{index} head: #{head}"
        xml # This case is used
    end
  end


  def set_node_multiple_all(nil, _, _, _), do: []
  def set_node_multiple_all(nil, _, _, _), do: []
  def set_node_multiple_all([], _, _, _), do: []
  def set_node_multiple_all(xml, [], _, _), do: xml
  def set_node_multiple_all(xml, [head | []], _, _) when is_bitstring(xml), do: xml
  def set_node_multiple_all(xml, [head | []], new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data == [] && is_bitstring(xml[:value]) -> nil
      data == [] -> xml
      true ->
        data |> Enum.reduce([], fn(x, acc) ->
          cond do
            elem(x, 0) == head -> acc ++ ["#{head}": [attrs: elem(x, 1)[:attrs], value: new_value]]
            true -> acc ++ ["#{elem(x, 0)}": [attrs: elem(x, 1)[:attrs], value: elem(x, 1)[:value]]]
          end
        end)
    end
  end
  def set_node_multiple_all(xml, [head | tail], new_value, index) do
    data = xml |> filter_xml(head, index)
    cond do
      data != nil && data[head] != nil && data[head] != [] -> # This case is used
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = set_node_multiple_all(x, tail, new_value, 0)
          {x, new_node}
        end)
        cond do
          node[head] == nil || (data == node && node[head] != nil) -> set_node_multiple_all(xml, [head | tail], new_value, index+1) # This case is used
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
      data != nil && data[head] != nil && index<length(data[head]) -> set_node_multiple_all(xml, [head | tail], new_value, index+1) # It seems that this case is never executed.
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
