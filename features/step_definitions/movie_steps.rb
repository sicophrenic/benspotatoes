Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  ratings = rating_list.split(', ')
  ratings.each do |rating|
    if uncheck
      step %Q{I uncheck "ratings[#{rating}]"}
    else
      step %Q{I check "ratings[#{rating}]"}
    end
  end
end

When /I (un)?check the following locations: (.*)/ do |uncheck, location_list|
  locations = location_list.split(', ')
  locations.each do |location|
    if uncheck
      step %Q{I uncheck "locations[#{location}]"}
    else
      step %Q{I check "locations[#{location}]"}
    end
  end
end

When /I (un)?check the following encodings: (.*)/ do |uncheck, encoding_list|
  encodings = encoding_list.split(', ')
  encodings.each do |encoding|
    if uncheck
      step %Q{I uncheck "encodings[#{encoding}]"}
    else
      step %Q{I check "encodings[#{encoding}]"}
    end
  end
end