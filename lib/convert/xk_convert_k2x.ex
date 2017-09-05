defmodule XKConvertK2X do
  def convert_K2X(xml, namespace_list, actual_namespace, level) when is_list(xml) do
    Enum.reduce(xml, "", fn({k,v}, acc)->
      actual_namespace = cond do
        namespace_list[k] != nil -> namespace_list[k]
        true -> actual_namespace
      end
      "#{acc}#{indent(level)}<#{actual_namespace}#{k} #{convert_attrs(v[:attrs])}>#{convert_K2X(v[:value], namespace_list, actual_namespace, level+1)}</#{actual_namespace}#{k}>"
    end)
  end
  def convert_K2X(xml, _, _, _) when is_bitstring(xml), do: xml
  def convert_attrs(attrs), do: Enum.reduce(attrs, "", fn({k,v}, acc)-> "#{acc} #{k}='#{v}'" end)
  defp indent(level), do: String.duplicate("\t", level)
end
