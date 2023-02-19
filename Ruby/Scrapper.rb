require 'open-uri'
require 'nokogiri'



url = "https://www.amazon.pl/gp/bestsellers?ref_=nav_cs_bestsellers"

headers = {

  'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36',

  'sec-ch-ua' => '"Not_A Brand";v="99", "Google Chrome";v="109", "Chromium";v="109"',

  'accept-language' => 'pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7'

}



html = URI.open(url, headers)

doc = Nokogiri::HTML(html)

product_cards = doc.css('div.p13n-sc-uncoverable-faceout')



puts "Today bestsellers list: \n"

puts "\n"



product_cards.each do |card|

  title = card.css('div.p13n-sc-truncate-desktop-type2.p13n-sc-line-clamp-4').text

  price = card.css('span._cDEzb_p13n-sc-price_3mJ9Z').text

  puts "Product with title: #{title}"

  puts "For the price of: #{price}"

  puts "\n"

end