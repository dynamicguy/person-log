# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

Role.delete_all
Authentication.delete_all
puts 'CREATING ROLES'
Role.create([
                { :name => 'admin' },
                { :name => 'user' },
                { :name => 'moderator' },
                { :name => 'VIP' }
            ], :without_protection => true)
puts 'SETTING UP DEFAULT USER LOGIN'
User.delete_all
user = User.create! :name => 'First User', :email => 'user@personlog.com', :password => 'please',
                    :bio => 'Digital Technology examines how the digital revolution is progressing. From the basics of digitising information of all kinds to explaining how digital-based technologies work.',
                    :gender => 'male',
                    :location => 'Dhaka, Bangladesh',
                    :phone => '+8801711234987',
                    :password_confirmation => 'please', :first_name => 'First', :last_name => 'User', :confirmed_at => Time.now
puts 'New user created: ' << user.name
user2 = User.create! :name => 'Second User', :email => 'user2@personlog.com',
                     :bio => 'The Harry Potter books are some of the bestselling books of all time. In this fascinating study, Susan Gunelius analyzes every aspect of the brand phenomenon that is Harry Potter.',
                     :gender => 'female',
                     :location => 'Dhaka, Bangladesh',
                     :phone => '+8801711123456',
                     :password => 'please', :password_confirmation => 'please', :first_name => 'Last', :last_name => 'User', :confirmed_at => Time.now
puts 'New user created: ' << user2.name
user.add_role :admin
user.add_role :moderator
user2.add_role :VIP