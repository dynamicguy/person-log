class User < ActiveRecord::Base
  rolify
  mount_uploader :avatar, AvatarUploader

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_protected :role_ids, :as => :admin
  #attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :avatar, :first_name, :last_name
  attr_protected :id
  #def name
  #  "#{first_name} #{last_name}" unless first_name.nil? and last_name.nil?
  #end
  #
  #def name=(name)
  #  split = name.split(' ', 2)
  #  self.first_name = split.first
  #  self.last_name = split.last
  #end
  #

end
