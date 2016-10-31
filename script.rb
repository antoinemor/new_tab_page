require "open-uri"
require "json"
require "date"

FLICKR_API_KEY = "8cf59e676f6aceed971e23853aa70d66"
FLICKR_API_CALL = "https://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=#{FLICKR_API_KEY}&user_id=111110089@N08&format=json&extras=url_o&per_page=100"
QUOTE_API_CALL = "http://quotes.rest/qod.json"

info = {}

photos_raw = open(FLICKR_API_CALL).read
photos_raw = photos_raw[14..photos_raw.length - 2]
photos = JSON.parse(photos_raw)
url_arr = []
photos["photos"]["photo"].each { |photo| url_arr << photo["url_o"] }
index = (Date.today.jd - Date.new(Date.today.year, 01, 01).jd) % (url_arr.length)
info[:img] = url_arr[index - 1]
greetings = ""

quote_raw = open(QUOTE_API_CALL).read
quote = JSON.parse(quote_raw)["contents"]["quotes"][0]
info[:quote] = "#{quote["quote"]} - #{quote["author"]}"

info[:time] = "#{Time.now.hour}:#{Time.now.min}"

greeting = case Time.now.hour
when (5..11) then "Good morning"
when (12..19) then "Good afternoon"
when (20..23) then "Good evening"
when (0..4) then "Good night"
end

info[:greeting] = "#{greeting} Antoine! Have fun!"
