# new_tab_page
(Work in progress)

A nice page to display when I open a new tab. Written in Ruby and deployed with the Sinatra gem.

Functionalities
- Picks one of my Flickr picture as background using the Flickr API
- Displays current time
- Wishes me good morning/afternoon/evening/night
- Displays a quote

To prevent multiple API calls, the app uses a CSV file to store the day's image url (the image is then cached by the browser, so no need to save it) and the quote.
