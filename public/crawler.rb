require 'mechanize'

agent = Mechanize.new
page = agent.get('http://google.com/')
google_form = page.form('f')
google_form.q = "site:boxofficemojo.com 50/50"
page = agent.submit(google_form)
page = page.link_with(:text=>/Box Office Mojo/).click
# DIRECTOR
page.body.match(/Director&id=.*.htm">(.*)<\/a>.*Actors:/)
puts $1
# RATING
page.body.match(/MPAA Rating: <b>(.*)<\/b>/)
$1.match(/(.*)<\/b>/)
puts $1
# RELEASE DATE
page.body.match(/Release Date:.*.htm">(.*)<\/a>.*Genre:/)
puts $1