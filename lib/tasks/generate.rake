namespace :generate do
  desc "generate users"
  task :users => :environment do
    lines = File.open(Rails.root + 'lib/tasks/male.txt', "r").readlines
    10.times.each do
      first_name = lines[rand(5..lines.size)]
      last_name = lines[rand(5..lines.size)]
      user = User.create! id: nil, phone: Faker::PhoneNumber.phone_number, bio: Faker::HipsterIpsum.paragraphs.join(" "), password: 'please', confirmed_at: Time.now, name: Faker::Name.name, email: Faker::Internet.email, address: [Faker::AddressUS.state, Faker::AddressUS.state_abbr, 'United States',].join(', '), gender: 'male'
      #user = User.create! :name => "#{first_name} #{last_name}",
      #                    :email => "#{first_name.downcase}.#{last_name.downcase}@personlog.com",
      #                    :password => 'please',
      #                    :password_confirmation => 'please',
      #                    :bio => 'some bio',
      #                    :remote_avatar_url => "http://a0.twimg.com/profile_images/1752949343/profile.png",
      #                    :confirmed_at => Time.now
      user.add_role :victim
      puts 'New user created: ' << user.name
    end
  end

end