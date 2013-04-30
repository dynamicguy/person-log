class FacebookFactory

  def self.import_friends(user_id)
    user = User.find(user_id)
    puts "fetching friends for #{user.name}"
    friends =get_friends(user)
    friends.each do |f|
      save_facebook_user(f, user) rescue nil
    end #end each
    puts "DONE"
  end

  def self.save_facebook_user(f, user)
    u = User.find_or_initialize_by_name_and_gender_and_email(f['name'], f['gender'], f['link'].split('/').last + '@facebook.com')
    u.confirmed_at = Time.now
    u.bio = f['bio']
    u.address = f['location']['name']
    u.remote_avatar_url = f['picture']['data']['url']
    u.password = Devise.friendly_token
    u.provider = 'facebook'
    u.uid = f['id']
    u.friends << user unless u.friends.include?(user)
    u.save
    user.friends << u unless user.friends.include?(u)
    user.save
    if f['education']
      f['education'].each do |education|
        edu = Education.find_or_initialize_by_school_and_field_of_study_and_user_id(:school => education['school']['name'], :field_of_study => education['type'], :user_id => u.id)
        if education['degree'].present?
          edu.degree = education['degree']['name']
        end
        if education['year'].present?
          edu.start_date = Date.new(education['year']['name'].to_i)
          edu.end_date = Date.new(education['year']['name'].to_i)
        end
        edu.save
      end
    end
    if f['work']
      f['work'].each do |p|
        company = Company.find_or_create_by_name(:name => p['employer']['name'])
        if p['location']
          company.location = p['location']['name']
          company.save
        end
        if p['position']
          position = Position.find_or_initialize_by_name_and_company_id_and_user_id(:name => p['position']['name'] || '', :company_id => company.id, :user_id => u.id)
          if p['description'].present?
            position.summary = p['description']
          end
          if p['start_date'].present?
            position.start_date = Date.new(p['start_date'].split('-').first.to_i, p['start_date'].split('-').last.to_i, 1)
          end
          if p['end_date'].present?
            position.end_date = Date.new(p['end_date'].split('-').first.to_i, p['end_date'].split('-').last.to_i, 1)
          end
          position.save
        end
      end
    end
    if f['link']
      u.urls.create(:title => 'facebook', :value => f['link'])
      u.save
    end
  end

  def self.get_friends(user)
    oauth_access_token = user.authentications.where({provider: "facebook"}).first.credentials.to_s.strip
    graph = Koala::Facebook::API.new(oauth_access_token)
    if Rails.env.development?
      graph.get_connections("me", "friends", {:fields => ' id, username, bio, address, picture.type(normal), gender, location, link, birthday, education, name, work ', :limit => 10})
    else
      graph.get_connections("me", "friends", {:fields => ' id, username, bio, address, picture.type(normal), gender, location, link, birthday, education, name, work '})
    end
  end

  def self.get_profile(user)
    oauth_access_token = user.authentications.where({provider: "facebook"}).first.credentials.to_s.strip
    graph = Koala::Facebook::API.new(oauth_access_token)
    graph.get_object("me")
  end

  def self.update_profile(user)
    profile = get_profile(user)
    update_positions(profile, user)
    update_educations(profile, user)
    profile
  end

  def self.update_educations(profile, u)
    user.educations.delete_all
    profile['education'].each do |education|
      edu = Education.find_or_initialize_by_school_and_field_of_study_and_user_id(:school => education['school']['name'], :field_of_study => education['type'], :user_id => u.id)
      if education['degree'].present?
        edu.degree = education['degree']['name']
      end
      if education['year'].present?
        edu.start_date = Date.new(education['year']['name'].to_i)
        edu.end_date = Date.new(education['year']['name'].to_i)
      end
      edu.save
    end
    user.save
  end

  def self.update_positions(profile, user)
    user.positions.delete_all
    profile['work'].each do |w|
      c = Company.find_or_initialize_by_name(:name => w['employer']['name'])
      if w['location']
        c.location = w['location']['name']
      end
      c.save
      if w['position'].present?
        position = Position.find_or_initialize_by_name_and_company_id_and_user_id(:name => w['position']['name'] || '', :company_id => c.id, :user_id => user.id)
        if w['start_date'].present?
          position.start_date = Date.new(w['start_date'].split('-').first.to_i, w['start_date'].split('-').last.to_i, 1)
        end
        if w['end_date'].present?
          position.end_date = Date.new(w['end_date'].split('-').first.to_i, w['end_date'].split('-').last.to_i, 1)
        end
        if w['description']
          position.description = w['description']
        end
        position.save
      end
    end
    user.save
  end


end