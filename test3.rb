p "aaa"
doc = Nokogiri::HTML(open('http://www.hkexnews.hk/listedco/listconews/mainindex/SEHK_LISTEDCO_DATETIME_TODAY_C.HTM'))
tmp=doc.css("tr.row0")

p "ab"
tmp.each_with_index do |t, i|
  if i==0
    stock_id=t.at_css("[width='54']").content
  else
    stock_id=t.at_css(".arial12black").content
  end
  stock_content=t.at_css("#hdLine").content
  stock_href="http://www.hkexnews.hk"+t.at_css(".news")["href"]
  p i.to_s+" "+stock_id+" "+stock_content+" "+stock_href
  stock_date=t.css("td").first.content
  stock_date.insert(10, " ")

  stock=Stock.find_by_code(stock_id[1, 4]+".HK")

  # m_exist=Micropost.find_by(stock: stock, created_at: stock_date.to_datetime)

  m_exist=Micropost.find_by(content:stock_content)

  if m_exist.nil?
    if !stock.nil?
      micropost=Micropost.new
      micropost.stock=stock
      micropost.content=stock_content+" "+stock_href
      micropost.user_id=1;
      micropost.microtype=1;
      micropost.randint=rand(100)
      micropost.created_at=stock_date.to_datetime
      micropost.created_at=micropost.created_at-Time.now.utc_offset
      micropost.save
    end
  end
end


tmp=doc.css("tr.row1")

tmp.each_with_index do |t, i|

  stock_id=t.at_css(".arial12black").content

  stock_content=t.at_css("#hdLine").content
  stock_href="http://www.hkexnews.hk"+t.at_css(".news")["href"]
  p i.to_s+" "+stock_id+" "+stock_content+" "+stock_href
  stock_date=t.css("td").first.content
  stock_date.insert(10, " ")

  stock=Stock.find_by_code(stock_id[1, 4]+".HK")

  # m_exist=Micropost.find_by(stock: stock, created_at: stock_date.to_datetime)

  m_exist=Micropost.find_by(content:stock_content)

  if m_exist.nil?
    if !stock.nil?
      micropost=Micropost.new
      micropost.stock=stock
      micropost.content=stock_content+" "+stock_href
      micropost.user_id=1;
      micropost.microtype=1;
      micropost.randint=rand(100)
      micropost.created_at=stock_date.to_datetime
      micropost.created_at=micropost.created_at-Time.now.utc_offset
      micropost.save
    end
  end
end
p "aaac"


