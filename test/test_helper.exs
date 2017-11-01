defmodule TestHelper do
  defp get_file(name) do
    {:ok, content} = File.read "./test/xmls/#{name}.xml"
    content
  end
  def get_content(), do: get_file("content")
  def get_mini_content(), do: get_file("mini_content")
  def get_short_content(), do: get_file("short_content")
  def get_deep_content(), do: get_file("deep_content")
  def get_duplicate_nodes_content(), do: get_file("duplicate_nodes")
  def get_match(name), do: get_file("match/#{name}")
  def normalize(body, content) do
    body    = Regex.replace(~r/\'/s, Regex.replace(~r/\\"/s, Regex.replace(~r/\t/s, Regex.replace(~r/\r/s, Regex.replace(~r/\\/s, Regex.replace(~r/\n/s, Regex.replace(~r/ /s, body, ""), ""), ""), ""), ""), "\""), "\"")
    content = Regex.replace(~r/\'/s, Regex.replace(~r/\\"/s, Regex.replace(~r/\t/s, Regex.replace(~r/\r/s, Regex.replace(~r/\\/s, Regex.replace(~r/\n/s, Regex.replace(~r/ /s, content, ""), ""), ""), ""), ""), "\""), "\"")
    {body, content}
  end
end
ExUnit.start()
