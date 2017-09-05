defmodule XKNodesSetter do
  def set_node(nil, _, _, _) do
    IO.puts "set_node 1"
    []
  end
  def set_node([], _, _, _) do
    IO.puts "set_node 2"
    []
  end
  def set_node(xml, [], _, _) do
    IO.puts "set_node 3"
    # IO.inspect xml
    # IO.puts "END set_node 3"
    xml
  end
  def set_node(xml, [head | []], _, _) when is_bitstring(xml), do: xml
  def set_node(xml, [head | []], new_value, index) do
    # IO.puts "set_node FINAL index: #{index} HEAD: #{head}"
    # IO.puts "HEAD: #{head} XML"
    # IO.inspect xml
    # IO.puts ""
    data = xml |> filter_xml(head, index)
    preserve = Keyword.get_values(data, head)
    try do
      # IO.puts "DATA"
      # IO.inspect data
      # IO.puts ""

      {x, node} = Keyword.get_and_update!(data, head, fn(x) ->
        # IO.puts "Ahora cambia la respuesta y da el valor de new_data que es: #{new_value}"
        {x, [attrs: x[:attrs], value: new_value]}
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
        # IO.puts "KEYERROR"
        # IO.puts ""
        # IO.inspect xml
        cond do
          data == [] && is_bitstring(xml[:value]) ->
            # IO.puts "KEYERROR condo 1"
            nil
          true ->
            # IO.puts "KEYERROR condo 2 true"
            xml # |> IO.inspect
        end
      e in FunctionClauseError ->
        # IO.puts "FunctionClauseError"
        # IO.puts ""
        xml # |> IO.inspect
      true ->
        # IO.puts "TRUE ERROR"
        # IO.puts ""
        xml # |> IO.inspect
    end
  end
  def set_node(xml, [head | tail], new_value, index) do
    data = xml |> filter_xml(head, index)
    # IO.puts ""
    # IO.puts "XML index: #{index} HEAD: #{head}"
    # IO.inspect data
    # IO.puts ""
    cond do
      data != nil && data[head] != nil && data[head] != [] ->#It is used
        # IO.puts "set_node condo 1.1 index: #{index} HEAD: #{head}"
        {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
          new_node = set_node(x, tail, new_value, 0)
          {x, new_node}
        end)
        cond do
          data == node && node[head] != nil -> #It is used
            # IO.puts "set_node condo 1.1.1 index: #{index} HEAD: #{head}"
            node # |> IO.inspect
            set_node(xml, [head | tail], new_value, index+1)
          node[head] == nil -> #It is used
            # IO.puts "set_node condo 1.1.2 index: #{index} HEAD: #{head}"
            set_node(xml, [head | tail], new_value, index+1) # |>  IO.inspect
          true -> #It is used
            IO.puts "set_node condo 1.1.3 TRUE index: #{index} HEAD: #{head}"
            attrs = cond do
              xml[head] != nil -> xml[head][:attrs]
              true -> xml[:attrs]
            end
            # IO.puts "attrs VALUE: "
            # attrs |> IO.inspect
            # IO.puts ""
            xml_ = basic_filter_xml(xml)
            preserve = Keyword.get_values(xml_, head)
            node_ = preserve |> Enum.reduce([], fn(x, acc) ->
              # IO.puts ""
              # IO.puts ""
              # IO.puts "ACCUMULATE"
              # IO.inspect node
              cond do
                x != data[head] ->
                  # IO.puts "PRESERVE condo 1 #{head}"
                  acc ++ ["#{head}": x]
                node[head] != nil -> acc ++ ["#{head}": [attrs: attrs, value: node[head]]]
                true ->
                  # IO.puts "PRESERVE condo 2 #{head}"
                  acc ++ [attrs: attrs, value: node]
              end
            end)
            # IO.puts "node VALUE: head:#{head}"
            # node |> IO.inspect
            # IO.puts "DATA VALUE:  head:#{head}"
            # data |> IO.inspect
            # IO.puts "XML VALUE:  head:#{head}"
            # xml |> IO.inspect
            # IO.puts "PRSERVE VALUE:  head:#{head}"
            # preserve |> IO.inspect
            # IO.puts "NODE_ VALUE:  head:#{head}"
            # node_ |> IO.inspect
            # IO.puts ""
            # IO.puts ""
            # IO.puts "XML VALUE: "
            # xml |> IO.inspect
            # IO.puts "NODE VALUE: "
            # IO.puts ""
            # IO.puts ""
             # |> IO.inspect
             node_
        end
        # cond do
        #   test_node(xml, head, tail) ->
        #     IO.puts "set_node condo 1.1.1 index: #{index} HEAD: #{head}"
        #     [attrs: xml[:attrs] ,value: node]
        #   true ->
        #     IO.puts "set_node condo 1.1.2 index: #{index} HEAD: #{head}"
        #     node_ = set_node(xml, [head | tail], new_value, index+1)
        #     Keyword.merge(["#{head}": node], node_)
        # end

      data != nil && data[head] != nil && index<length(data[head]) -> #It seems that never execute this snippet.
        # IO.puts "set_node condo 1.2 index: #{index} HEAD: #{head}"
        # IO.puts "data VALUE"
        # IO.inspect data
        # IO.puts "NODE VALUE"
        set_node(xml, [head | tail], new_value, index+1) # |> IO.inspect
        # node = set_node(xml, [head | tail], new_value, index+1)
        # cond do
        #   node != nil && data[:value] == nil ->
        #     IO.puts "set_node condo 1.2.1 index: #{index} HEAD: #{head}"
        #     Keyword.merge([value: data], node)
        #   node != nil ->
        #     IO.puts "set_node condo 1.2.2 index: #{index} HEAD: #{head}"
        #     Keyword.merge(data, node)
        #   true ->
        #     IO.puts "set_node condo 1.2.3 TRUE index: #{index} HEAD: #{head}"
        #     []
        # end
      true -> #It is used
        # IO.puts "set_node condo 1.3 TRUE index: #{index} HEAD: #{head}"
        xml
    end
  end
  defp filter_xml(xml, head, index) do
    xml = basic_filter_xml(xml)
    # IO.puts ""
    # IO.puts "filter_xml"
    # IO.puts "XML index: #{index} HEAD: #{head}. Length: #{length(xml)}"
    # IO.inspect xml
    # IO.puts ""
    cond do
      xml |> is_bitstring -> []
      xml == nil || index>length(xml) || Enum.at(xml, index)==nil -> []
      xml[head] == nil -> []
      true ->
        # IO.puts "filter_xml condo TRUE INDEX: #{index} HEAD: #{head}"
        # IO.inspect xml
        {head_, xml_} = xml |> Enum.at(index)
        # IO.puts "THE HEAD_ #{head_}"
        # IO.puts ""
        cond do
          head_ == head -> ["#{head}": xml_]
          # true -> ["#{head}": xml[head]]
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
  defp test_node(xml, head, [tail | _]) do

    xml = basic_filter_xml(xml)
    cond do
      xml != nil && xml[head] != nil && xml[head][:value] != nil && xml[head][:value][tail] != nil -> false
      true -> true
      # xml != nil && xml[head] != nil && xml[head][:value] != nil -> false
      # xml != nil && xml[head] != nil -> false
      # xml != nil -> false
      # true -> true
    end
  end







  # def set_node(xml, [], _, _), do: nil
  # def set_node(xml, [head | []], new_value, index) do
  #   data = xml |> filter_xml(index)
  #   {x, node} = Keyword.get_and_update!(data, head, fn(x) ->
  #     {x, [attrs: x[:attrs], value: new_value]}
  #   end)
  #   [attrs: xml[:attrs], value: node]
  # end
  # def set_node(xml, [head | tail], new_value, index) do
  #     data = xml |> filter_xml(index)
  #     {_, node} = Keyword.get_and_update!(data, head, fn(x) ->
  #       new_node = set_node(x, tail, new_value, index)
  #       {x, new_node}
  #     end)
  #     [attrs: xml[:attrs] ,value: node]
  #     # set_node(xml, [head | tail], new_value, index+1)
  # end
  # defp filter_xml(xml, _) do
  #   cond do
  #     xml[:value] != nil -> xml[:value]
  #     true -> xml
  #   end
  # end
end
