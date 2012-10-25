class User < ActiveRecord::Base
  rolify
  mount_uploader :avatar, AvatarUploader
  paginates_per 20
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  #attr_protected :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :avatar, :first_name, :last_name
  attr_accessible :tag_list, :avatar_cache, :role_ids, :confirmed_at
  attr_accessible :provider, :uid

  acts_as_taggable
  has_many :authentications

  scope :by_join_date, order("created_at DESC")

  searchable do
    text :name
    text :email
    integer :tag_list, :multiple => true
    time    :created_at
    time    :updated_at
    string  :sort_name do
      name.downcase.gsub(/^(an?|the)/, '')
    end
  end

end
