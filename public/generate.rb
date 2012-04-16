#! /usr/bin/ruby

require 'mechanize'

# Title
# Director
# Rating
# Location
# Quality
# Release Date

title, director, rating, location, quality, release = "","","","","",""
months = { "January" => "Jan", "February" => "Feb", "March" => "Mar", "April" => "Apr", "May" => "May", "June" => "Jun", "July" => "Jul", "August" => "Aug", "September" => "Sep", "October" => "Oct", "November" => "Nov", "December" => "Dec" }
writeFile = File.open('allpotatoes.041612.rb','r+')
# puts 'List of Movies (filename)?:'
# inFile = gets
File.open('allpotatoes.041612.tsv','r') do |opened|
  while title = opened.gets
    agent = Mechanize.new
    page = agent.get('http://google.com')
    google_form = page.form('f')
    google_form.q = "site:boxofficemojo.com #{title}"
    page = agent.submit(google_form)
    page = page.link_with(:text=>/Box Office Mojo/).click
    puts 'Title: '+title
    # DIRECTOR
    page.body.match(/Director&id=.*.htm">(.*)<\/a>.*Writers?:/)
    director = $1 || nil
    page.body.match(/Director&id=.*.htm">(.*)<\/a>.*Actors:/)
    check = $1
    if director != check && director == nil
      director = check || ""
    elsif director == nil
      director = ""
    end
    puts 'Director: '+director
    # RATING
    page.body.match(/MPAA Rating: <b>(.*)<\/b>/)
    $1.match(/(.*)<\/b>/)
    rating = $1
    puts 'Rating: '+rating
    # LOCATION
    puts 'Location?'
    location = gets
    # QUALITY
    puts 'Quality?'
    quality = gets
    # RELEASE DATE
    page.body.match(/Release Date:.*.htm">(.*)<\/a>.*Genre:/)
    origRelease = $1
    if origRelease == nil
      page.body.match(/Release Date: .*<nobr>(.*)<\/nobr>/)
      origRelease = $1
    end
    release = origRelease.gsub(',','')
    release = release.split
    day = release[1]
    month = months[release[0]]
    release[0] = day
    release[1] = month
    release = release.join('-')
    puts 'Release Date: '+origRelease+' => '+release
    line = "\t\t{:title => '#{title}', :director => '#{director}', :rating => '#{rating}', :location => '#{location}', :quality => '#{quality}', :release_date => '#{release}'},"
    line = line.gsub(/\n/,'')
    line << "\n"
    writeFile.write(line)
  end
end