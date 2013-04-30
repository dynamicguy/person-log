namespace :rdf do
  desc "import people from rdf"
  task :import => :environment do
    puts "starting import"
    # curl http://downloads.dbpedia.org/3.8/en/persondata_en.nt.bz2 > persondata_en.nt.bz2
    # bunzip2 persondata_en.nt.bz2 && RAILS_ENV=production rake rdf:import
    RDF::Reader.open("persondata_en.nt", :format => :nquads) do |reader|
      list = []
      reader.each_statement do |statement|
        url = statement.subject.to_s
        if list.include?(url)
          puts '[SKIPPING] already crawled: ' + url
        else
          list.push(url)
          puts 'fetching url: ' + url
          begin
            node=Nokogiri::HTML(open(url))
            country = node.search('a[@rel="dbpedia-owl:country"]').text.split(':')[1].titleize rescue nil
            name = node.search('h1#title').text.split(':')[1].strip
            email=name.downcase.gsub(/&/, 'and').gsub(/\s+/, '-').gsub(/[^a-z0-9-]/, '') + '@personlog.com'

            u = User.find_or_initialize_by_name_and_email(name, email)
            #u.country = country
            u.bio = node.search('div[@id=content] p:first').text
            u.birthday = node.search('span[@property="dbpprop:birthDate"]').text.to_date rescue nil
            u.deathday = node.search('span[@property="dbpprop:deathDate"]').text.to_date rescue nil
            u.birthplace = node.search('span[@property="dbpprop:birthPlace"]').text rescue nil
            u.address = u.birthplace if u.birthplace.present?
            if country
              u.address = country unless u.address.present?
            end
            photo = node.search('a[@rel="dbpedia-owl:thumbnail nofollow"]').text
            u.remote_avatar_url = photo if photo.present?
            u.tag_list = node.search('a[@rel="dbpedia-owl:occupation"]').collect { |n| n.text.split(':')[1] }
            u.provider = 'dbpedia'
            u.password = Devise.friendly_token[0, 20]
            u.published=true
            u.published_at=Time.now
            u.save
            urls = node.search('a[@rel="dbpedia-owl:wikiPageExternalLink nofollow"]').collect { |n| n.text }
            for url in urls
              u.urls.create(:title => url, :value => url)
            end
          rescue
            @error_message="#{$!}"
          end
        end
      end
      list.uniq.each do |url|

      end
    end

    puts "DONE"
  end
end