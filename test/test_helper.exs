defmodule TestHelper do
  @short_content "<Bookstore blop='blup'>
    <Booking id='0' class='terror booking'>
      <International attr='I_0'></International>
    </Booking>
    <Booking id='1' class='terror booking'>
      <International attr='I_1'>
        <ISBN type='international'>ISBN_booking</ISBN>
        <Name>The Booking Letcture</Name>
        <Author>Randy Pausch</Author>
      </International>
      <Other>something</Other>
      <Other>something_2</Other>
      <Other>something_3</Other>
    </Booking>
    <Booking id='2' class='The_third'>
      <International attr='I_2'></International>
    </Booking>
  </Bookstore>"
  @content "<Bookstore>
    <Booking id='0' class='terror booking'>
      <ISBN type='international'>ISBN_booking</ISBN>
      <Name>The Booking Letcture</Name>
      <Author>Randy Pausch</Author>
    </Booking>
    <Book id='1' class='terror'>
      <ISBN type='international'>ISBN_1</ISBN>
      <Name>The Last Letcture</Name>
      <Author>Randy Pausch</Author>
    </Book>
    <Book id='2' class='sci-fic' seller='second'>
      <ISBN type='national'>ISBN_2</ISBN>
      <Name>The Cool Letcture</Name>
      <Author>Randy Orton</Author>
      <Unique valid='true'>true</Unique>
    </Book>
    <Book id='3' class='comedy' seller='best'>
      <ISBN type='EU'>
        <special>ISBN_3</special>
      </ISBN>
      <Name>The Legend</Name>
      <Author>Mike San Francisco</Author>
    </Book>
  </Bookstore>"
  @deep_content "<Bookstore>
    <Book id='3' class='comedy' seller='best'>
      <Author>
        <Other></Other>
      </Author>
      <Author>
        <Name>
          <Given>
            <ISBN type='EU'>
              <special attr='value'>ISBN_3</special>
            </ISBN>
          </Given>
        </Name>
      </Author>
    </Book>
  </Bookstore>"
  @content_with_namespaces "<Bookstore >
    <Booking  id='0' class='terror booking'>
      <ISBN  type='international'>ISBN_booking</ISBN>
      <Name>The Booking Letcture</Name>
      <Author>Randy Pausch</Author>
    </Booking>
    <n:Book  id='1' class='terror'>
      <ISBN  type='international'>ISBN_1</ISBN>
      <n:Name>The Last Letcture</n:Name>
      <n:Author >Randy Pausch</n:Author>
    </n:Book>
    <n:Book  id='2' class='sci-fic' seller='second'>
      <ISBN  type='national'>ISBN_2</ISBN>
      <n:Name >The Cool Letcture</n:Name>
      <n:Author >Randy Orton</n:Author>
      <n:Unique  valid='true'>true</n:Unique>
    </n:Book>
    <n:Book  id='3' class='comedy' seller='best'>
      <ISBN  type='EU'><special >ISBN_3</special></ISBN>
      <n:Name >The Legend</n:Name>
      <n:Author >Mike San Francisco</n:Author>
    </n:Book>
  </Bookstore>"


  def get_content(), do: @content
  def get_short_content(), do: @short_content
  def get_deep_content(), do: @deep_content
  def get_content_with_namespaces(), do: @content_with_namespaces
  def normalize(body, content) do
    body    = Regex.replace(~r/\t/s, Regex.replace(~r/\r/s, Regex.replace(~r/\\/s, Regex.replace(~r/\n/s, Regex.replace(~r/ /s, body, ""), ""), ""), ""), "")
    content = Regex.replace(~r/\t/s, Regex.replace(~r/\r/s, Regex.replace(~r/\\/s, Regex.replace(~r/\n/s, Regex.replace(~r/ /s, content, ""), ""), ""), ""), "")
    {body, content}
  end
end
ExUnit.start()
