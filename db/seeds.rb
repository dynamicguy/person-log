# ruby encoding: utf-8

User.delete_all
Role.delete_all
Authentication.delete_all
Company.delete_all
Position.delete_all
Url.delete_all
Education.delete_all

puts 'CREATING ROLES'
Role.create([
                { :name => 'admin' },
                { :name => 'user' },
                { :name => 'moderator' },
                { :name => 'VIP' }
            ], :without_protection => true)
puts 'SETTING UP DEFAULT USER LOGIN'
admin = User.create! :name => 'Admin User',
                    :provider => 'email',
                    :email => 'admin@personlog.com',
                    :password => 'please',
                    :password_confirmation => 'please',
                    :bio => 'Digital Technology examines how the digital revolution is progressing. From the basics of digitising information of all kinds to explaining how digital-based technologies work.',
                    :gender => 'male',
                    :address => 'Dhaka, Bangladesh',
                    :phone => '+8801711234987',
                    :confirmed_at => Time.now
puts 'New user created: ' << admin.name
moderator = User.create! :email => 'moderator@personlog.com',
                     :provider => 'email',
                     :bio => 'The Harry Potter books are some of the bestselling books of all time. In this fascinating study, Susan Gunelius analyzes every aspect of the brand phenomenon that is Harry Potter.',
                     :gender => 'female',
                     :address => 'Dhaka, Bangladesh',
                     :phone => '+8801711123456',
                     :password => 'please',
                     :password_confirmation => 'please',
                     :name => 'Moderator User',
                     :confirmed_at => Time.now
puts 'New user created: ' << moderator.name
user = User.create! :email => 'user@personlog.com',
                     :provider => 'email',
                     :bio => 'The Harry Potter books are some of the bestselling books of all time. In this fascinating study, Susan Gunelius analyzes every aspect of the brand phenomenon that is Harry Potter.',
                     :gender => 'female',
                     :address => 'Dhaka, Bangladesh',
                     :phone => '+8801711123456',
                     :password => 'please',
                     :password_confirmation => 'please',
                     :name => 'User User',
                     :confirmed_at => Time.now
puts 'New user created: ' << user.name
admin.add_role :admin
moderator.add_role :moderator
user.add_role :user

#100.times {|i| User.create! :name => "User #{i+3}", :email => "user#{i+3}@example.com", :password => 'please', :password_confirmation => 'please'}