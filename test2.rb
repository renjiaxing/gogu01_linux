p "aaa"
doc = Nokogiri::HTML(open('http://www.hkexnews.hk/listedco/listconews/mainindex/SEHK_LISTEDCO_DATETIME_TODAY_C.HTM'))
tmp=doc.css("tr.row0")

p "ab"
