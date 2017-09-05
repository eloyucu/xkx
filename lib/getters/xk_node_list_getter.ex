defmodule XKNodesListGetter do

  def get_node_value_list(nil, path, _, acc), do: acc
  def get_node_value_list(xml, [], _, acc) do
    cond do
      is_binary(xml) -> acc
      true -> [xml ++ acc]
    end
  end
  def get_node_value_list(xml, [head | []], _, acc) do
    cond do
      is_binary(xml |> Keyword.get(:value)) -> acc
      xml[head] != nil -> [xml[head][:value]]
      true -> acc
    end
  end
  def get_node_value_list(xml, [head | tail], index, acc) do
    cond do
      xml |> Keyword.get(:value) != nil && is_binary(xml |> Keyword.get(:value)) ->
        get_node_value_list(xml, tail, index, acc)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && is_binary(xml[head] |> Keyword.get(:value)) ->
        get_node_value_list(xml[head], tail, index, acc)
      xml |> Keyword.get(:value) != nil && index<length(xml |> Keyword.get(:value)) ->
        get_node_value_list_aux(xml, [head | tail], index, acc)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && index<length(xml[head] |> Keyword.get(:value)) ->
        get_node_value_list_aux(xml, [head | tail], index, acc)
      true -> acc
    end
  end
  # def get_node_value_list(xml, head, _), do: xml[head][:value]
  defp get_node_value_list_aux(xml, [head | tail], index, acc) do
    xml = cond do
      xml[head] != nil -> [value: xml]
      true -> xml
    end
    node = Enum.at(xml |> Keyword.get(:value), index)
    cond do
      elem(node,0) == head ->
        node = node |> elem(1) |> Keyword.get(:value) |> get_node_value_list(tail, 0, acc)
        cond do
          node == nil -> get_node_value_list(xml, [head | tail], index+1, acc)
          true -> get_node_value_list(xml, [head | tail], index+1, node ++ acc)
        end
      true -> get_node_value_list(xml, [head | tail], index+1, acc)
    end
  end


  def get_node_list(nil, path, _, _), do: nil
  def get_node_list(xml, [], _, acc) do
    cond do
      is_binary(xml) -> acc
      true -> [xml ++ acc]
    end
  end
  def get_node_list(xml, [head | []], _, acc) do
    cond do
      is_binary(xml |> Keyword.get(:value)) -> acc
      xml[head] != nil -> [xml[head]]
      true -> [xml[:value][head]]
    end
  end
  def get_node_list(xml, [head | tail], index, acc) do
    cond do
      xml |> Keyword.get(:value) != nil && is_binary(xml |> Keyword.get(:value)) ->
        get_node_list(xml, tail, index, acc)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && is_binary(xml[head] |> Keyword.get(:value)) ->
        get_node_list(xml[head], tail, index, acc)
      xml |> Keyword.get(:value) != nil && index<length(xml |> Keyword.get(:value)) ->
        get_node_list_aux(xml, [head | tail], index, acc)
      xml[head] != nil && xml[head] |> Keyword.get(:value) != nil && index<length(xml[head] |> Keyword.get(:value)) ->
        get_node_list_aux(xml, [head | tail], index, acc)
      true -> acc
    end
  end
  defp get_node_list_aux(xml, [head |  tail], index, acc) do
    xml = cond do
      xml[head] != nil -> [value: xml]
      true -> xml
    end
    node = Enum.at(xml |> Keyword.get(:value), index)
    cond do
      elem(node,0) == head ->
        node = node |> elem(1) |> Keyword.get(:value) |> get_node_list(tail, 0, acc)
        cond do
          node == nil -> get_node_list(xml, [head | tail], index+1, acc)
          true -> get_node_list(xml, [head | tail], index+1, node ++ acc)
        end
      true ->
        get_node_list(xml, [head | tail], index+1, acc)
    end
  end
end
