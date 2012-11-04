class User < ActiveRecord::Base
  rolify
  mount_uploader :avatar, AvatarUploader
  paginates_per 20
  has_paper_trail
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:twitter, :facebook, :google_oauth2, :github, :linkedin]

  # Setup accessible (or protected) attributes for your model
  attr_protected :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :first_name, :last_name
  attr_accessible :tag_list, :avatar, :avatar_cache, :remove_avatar, :remote_avatar_url, :role_ids, :confirmed_at
  attr_accessible :provider, :uid, :bio, :gender, :location, :phone

  acts_as_taggable
  has_many :authentications

  scope :by_join_date, order("created_at DESC")

  searchable do
    text :name
    text :bio
    string :email
    integer :tag_list, :multiple => true
    time :created_at
    time :updated_at
    string :sort_name do
      name.downcase.gsub(/^(an?|the)/, '')
    end
  end

  validates :name, :presence => true
  validates :email, :presence => true

  # ==========  USER METHODS  =========== #
  def apply_omniauth(omniauth, confirmation)
    self.email = omniauth['user_info']['email'] if email.blank?
    # Check if email is already into the database => user exists
    apply_trusted_services(omniauth, confirmation) if self.new_record?
  end

  # Create a new user
  def apply_trusted_services(omniauth, confirmation)
    # Merge user_info && extra.user_info
    user_info = omniauth['info']
    if omniauth['extra'] && omniauth['extra']['user_hash']
      user_info.merge!(omniauth['extra']['user_hash'])
    end
    # try name or nickname
    if self.name.blank?
      self.name = user_info['name'] unless user_info['name'].blank?
      self.name ||= user_info['nickname'] unless user_info['nickname'].blank?
      self.name ||= (user_info['first_name']+" "+user_info['last_name']) unless \
                                                       user_info['first_name'].blank? || user_info['last_name'].blank?
    end
    if self.email.blank?
      self.email = user_info['email'] unless user_info['email'].blank?
    end
  end

  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
    else
      user = User.where(:email => auth.info.email).first
      unless user
        user = User.create(name: auth.info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           email: auth.info.email,
                           bio: auth.info.description,
                           remote_avatar_url: auth.info.image.to_s.gsub("square", "large"),
                           password: Devise.friendly_token[0, 20],
                           phone: auth.info.phone,
                           location: auth.info.location,
                           gender: auth.extra.raw_info.gender,
                           confirmed_at: Time.now
        )
      end
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
    else
      user = User.where(:email => auth.info.nickname + '@personlog.com').first
      unless user
        user = User.create(name: auth.info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           bio: auth.info.description,
                           remote_avatar_url: auth.info.image.to_s.gsub("_normal", ""),
                           email: auth.info.nickname + '@personlog.com',
                           password: Devise.friendly_token[0, 20],
                           phone: auth.info.phone,
                           location: auth.info.location,
                           confirmed_at: Time.now
        )
      end
    end
    user
  end

  def self.find_for_linkedin_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
    else
      user = User.where(:email => auth.info.email).first
      unless user
        user = User.create(name: auth.info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           bio: auth.info.description + ' in ' + auth.info.industry + ' industry',
                           remote_avatar_url: auth.info.image.to_s.gsub("_normal", ""),
                           email: auth.info.email,
                           password: Devise.friendly_token[0, 20],
                           phone: auth.info.phone,
                           location: auth.extra.raw_info.location.name,
                           confirmed_at: Time.now
        )
      end
    end
    user
  end

  def self.find_for_github_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
    else
      user = User.where(:email => auth.info.email).first
      unless user
        user = User.create(name: auth.info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           bio: auth.extra.raw_info.bio,
                           remote_avatar_url: auth.info.image,
                           email: auth.info.email,
                           password: Devise.friendly_token[0, 20],
                           phone: auth.info.phone,
                           location: auth.extra.raw_info.location,
                           confirmed_at: Time.now
        )
      end
    end
    user
  end

  def self.find_for_google_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
    else
      user = User.where(:email => auth.info.email).first
      unless user
        user = User.create(name: auth.info.name,
                           provider: auth.provider,
                           uid: auth.uid,
                           bio: auth.info.description || '',
                           remote_avatar_url: auth.info.image,
                           email: auth.info.email,
                           password: Devise.friendly_token[0, 20],
                           phone: auth.info.phone || '',
                           location: auth.extra.raw_info.location || '',
                           confirmed_at: Time.now
        )
      end
    end
    user
  end

end
