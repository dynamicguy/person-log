namespace :generate do
  desc "generate users"
  task :users => :environment do
    lines = File.open(Rails.root + 'lib/tasks/male.txt', "r").readlines
    1000.times.each do
      first_name = lines[rand(5..lines.size)]
      last_name = lines[rand(5..lines.size)]
      user = User.create! :name => "#{first_name} #{last_name}",
                          :email => "#{first_name.downcase}.#{last_name.downcase}@personlog.com",
                          :password => 'please',
                          :password_confirmation => 'please',
                          :first_name => first_name,
                          :last_name => last_name,
                          :confirmed_at => Time.now
      user.add_role :user
      puts 'New user created: ' << user.name
    end
  end

end