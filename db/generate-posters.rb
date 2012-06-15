require 'imdb'

Movie.all.each do |movie|
  puts movie.title
  skip = ["Black Hawk Down", "Bond: Die Another Day", "Bond: From Russia With Love", "Bond: License to Kill","Bond: Quantum of Solace",
    "Bond: The Man with the Golden Gun", "Bond: Thunderball", "Bond: Tomorrow Never Dies", "Drunken Master", "Finding Nemo", "Gladiator",
    "Harry Potter and the Deathly Hallows Part I", "Harry Potter and the Deathly Hallows Part II", "Mission Impossible I",
    "The Fast and the Furious: Fast and Furious", "The Fast and the Furious: Fast Five", "The Fast and the Furious: Too Fast Too Furious",
    "The Karate Kid", "The Lion King", "The Mummy", "The Mummy Returns", "The Terminator: Judgement Day"]
  if skip.include?(movie.title)
    case movie.title
    when "Black Hawk Down"
      pstr = "http://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Black_hawk_down_ver1.jpg/220px-Black_hawk_down_ver1.jpg"
      movie.update_attribute(:poster, pstr)
    when "Bond: Die Another Day"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTM2NzY2NjMwMF5BMl5BanBnXkFtZTYwOTUyMDg5.jpg"
      movie.update_attribute(:poster, pstr)
    when "Bond: From Russia With Love"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTQxNTIzMTExN15BMl5BanBnXkFtZTcwODI4MDgzNA@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Bond: License to Kill"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTY0NDE2MTAzN15BMl5BanBnXkFtZTcwMjY5MDg0NA@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Bond: Quantum of Solace"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTY0MjI4MDI5MF5BMl5BanBnXkFtZTcwODkwNjk3MQ@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Bond: The Man with the Golden Gun"
      pstr = "http://ia.media-imdb.com/images/M/MV5BODg3NjQ0MjMwN15BMl5BanBnXkFtZTcwNTY5MDg0NA@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Harry Potter and the Deathly Hallows Part I"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTQ2OTE1Mjk0N15BMl5BanBnXkFtZTcwODE3MDAwNA@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Harry Potter and the Deathly Hallows Part II"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTY2MTk3MDQ1N15BMl5BanBnXkFtZTcwMzI4NzA2NQ@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Bond: Thunderball"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTY1Mjc2MTYxNV5BMl5BanBnXkFtZTcwNzUzMzY3NA@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Bond: Tomorrow Never Dies"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTM1MTk2ODQxNV5BMl5BanBnXkFtZTcwOTY5MDg0NA@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "Drunken Master"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTc1NjYxMTExNl5BMl5BanBnXkFtZTYwNTU2NTI5._V1_.jpg"
      movie.update_attribute(:poster, pstr)
    when "Finding Nemo"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTYxMjIzMDE0M15BMl5BanBnXkFtZTcwNjM1OTM2MQ@@._V1_.jpg"
      movie.update_attribute(:poster, pstr)
    when "Gladiator"
      pstr = "http://upload.wikimedia.org/wikipedia/en/8/8d/Gladiator_ver1.jpg"
      movie.update_attribute(:poster, pstr)
    when "Mission Impossible I"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMjAyNjk5Njk0MV5BMl5BanBnXkFtZTcwOTA4MjIyMQ@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Fast and the Furious: Fast and Furious"
      pstr = "http://upload.wikimedia.org/wikipedia/en/8/8f/Fast_and_Furious_Poster.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Fast and the Furious: Fast Five"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTUxNTk5MTE0OF5BMl5BanBnXkFtZTcwMjA2NzY3NA@@.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Fast and the Furious: Too Fast Too Furious"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTIyMDUwMDc4OF5BMl5BanBnXkFtZTYwNTY2Nzk5.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Karate Kid"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTQ0ODg3ODEyMF5BMl5BanBnXkFtZTcwNjI1MTgxMw@@._V1_.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Lion King"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTU0NTI3NTMxNF5BMl5BanBnXkFtZTYwNDUwMTQ3._V1_.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Mummy"
      pstr = "http://upload.wikimedia.org/wikipedia/en/6/68/The_mummy.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Mummy Returns"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTU2ODg4NzMzNl5BMl5BanBnXkFtZTYwNjczMjE5._V1_.jpg"
      movie.update_attribute(:poster, pstr)
    when "The Terminator: Judgement Day"
      pstr = "http://ia.media-imdb.com/images/M/MV5BMTg5NzUwMDU5NF5BMl5BanBnXkFtZTcwMjk2MDA4Mg@@.jpg"
      movie.update_attribute(:poster, pstr)
    end
    puts "Skipping "+movie.title+"!"
    next
  end
  if movie.poster != '/assets/defaultposter.png'
    next
  end
  pstr = Imdb::Search.new(movie.title).movies().first.poster()
  movie.update_attribute(:poster, pstr)
end