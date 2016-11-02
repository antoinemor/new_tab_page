require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require "open-uri"
require "json"
require "date"
require_relative "csv_methods"
configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do

  # Constants initialization
  FLICKR_API_KEY = ""
  FLICKR_API_CALL = "https://api.flickr.com/services/rest/?&method=flickr.people.getPublicPhotos&api_key=#{FLICKR_API_KEY}&user_id=111110089@N08&format=json&extras=url_o&per_page=100"
  QUOTE_API_CALL = "http://quotes.rest/qod.json"

  # CSV check
  csv_file = File.join(__dir__, 'day_data.csv')
  output_csv = read_csv(csv_file)
  if output_csv[0].to_i == Date.today.jd
    @info = { img: output_csv[1], quote: output_csv[2] }
  else
    # Get Flickr URL from API
    @info = {}
    photos_raw = open(FLICKR_API_CALL).read
    photos_raw = photos_raw[14..photos_raw.length - 2]
    photos = JSON.parse(photos_raw)
    url_arr = []
    photos["photos"]["photo"].each { |photo| url_arr << photo["url_o"] }
    index = (Date.today.jd - Date.new(Date.today.year, 01, 01).jd) % (url_arr.length)
    @info[:img] = url_arr[index - 1]

    # Get quote from API
    quote_raw = open(QUOTE_API_CALL).read
    quote = JSON.parse(quote_raw)["contents"]["quotes"][0]
    @info[:quote] = "#{quote["quote"]} - #{quote["author"]}"

    # Store data into CSV
    content = [Date.today.jd, @info[:img], @info[:quote]]
    write_csv(csv_file, content)
  end

  # Time generation
  @info[:time] = "#{Time.now.hour}:#{sprintf('%02d', Time.now.min)}"

  # Greetings generation
  greeting = case Time.now.hour
  when (5..11) then "Good morning"
  when (12..19) then "Good afternoon"
  when (20..23) then "Good evening"
  when (0..4) then "Good night"
  end
  @info[:greeting] = "#{greeting} Antoine!"

  # Call new_tab
  erb :new_tab
end
