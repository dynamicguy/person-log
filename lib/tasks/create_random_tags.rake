namespace :db do
  desc "Create random and tags."
  task :create_random_bio => :environment do
    dict_word_count = `wc -l /usr/share/dict/words | awk '{print $1}'`.to_i
    facet_words = 200.times.map { `sed $(echo #{Random.rand(dict_word_count)})"q;d" /usr/share/dict/words`.strip! }
    User.all.each do |u|
      words = 160.times.collect { facet_words[rand(facet_words.size)].strip }
      u.bio = words.join(' ')
      u.save
    end
  end

  desc "Create random names."
  task :create_random_names => :environment do
    dict_word_count = `wc -l /usr/share/dict/propernames | awk '{print $1}'`.to_i
    facet_words = 100.times.map { `sed $(echo #{Random.rand(dict_word_count)})"q;d" /usr/share/dict/propernames`.strip! }
    User.all.each do |u|
      words = 2.times.collect { facet_words[rand(facet_words.size)].strip }
      u.name = words.join(' ')
      u.save
    end


  end

  desc "Create random and tags."
  task :create_random_tags => :environment do
    dict_word_count = `wc -l /usr/share/dict/words | awk '{print $1}'`.to_i
    facet_words = 100.times.map { `sed $(echo #{Random.rand(dict_word_count)})"q;d" /usr/share/dict/words`.strip! }
    User.all.each do |u|
      u.tag_list = 10.times.map { facet_words[rand(facet_words.size)] }
      u.save
    end
  end
end