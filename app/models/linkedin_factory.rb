class LinkedinFactory

  API_KEY = '5tcdejy8tca8'
  SECRET_KEY = '1YcYOSs2LKzxHuiD'

  def self.import_friends(user_id)
    user = User.find(user_id)
    puts "fetching connections for #{user.name}"
    connections = self.get_connections(user)
    puts "found #{connections.size} connections"
    User.import_linkedin_connections(user, connections)
    puts "DONE"
  end

  def self.authorize_user(user)
    token = user.authentications.where({provider: "linkedin"}).first.credentials.split(' ')[0]
    secret = user.authentications.where({provider: "linkedin"}).first.credentials.split(' ')[1]
    client = LinkedIn::Client.new(API_KEY, SECRET_KEY)
    client.authorize_from_access(token, secret)
    client
  end

  def self.get_connections(user)
    client = self.authorize_user(user)
    if (Rails.env == "development")
      client.connections(start: 0, count: 5, :fields => ["id", "picture-url", "public-profile-url", "phone-numbers", "location",
                                                         "first-name", "last-name", "headline", "industry", "summary", "specialties",
                                                         "educations", "languages", "positions"])
    else
      client.connections(:fields => ["id", "picture-url", "public-profile-url", "phone-numbers", "location",
                                     "first-name", "last-name", "headline", "industry", "summary", "specialties",
                                     "educations", "languages", "positions"])
    end
  end

  def self.get_profile(user)
    client = self.authorize_user(user)
    client.profile(:id => user.authentications.where({provider: "linkedin"}).first.uid, :fields => ["picture-url", "public-profile-url", "phone-numbers", "location", "first-name", "last-name", "headline", "industry", "summary", "specialties", "educations", "languages", "positions"])
  end

  def self.update_profile(current_user)
    p = self.get_profile(current_user)
    User.import_educations_from_linkedin(p, current_user)
    current_user.bio = p.summary
    current_user.tag_list = p.specialties
    User.import_positions_from_linkedin(p, current_user)
    current_user.save
  end

end