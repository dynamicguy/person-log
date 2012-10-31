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
  attr_accessible :provider, :uid, :bio

  acts_as_taggable
  has_many :authentications

  scope :by_join_date, order("created_at DESC")

  searchable do
    text :name
    text :email
    integer :tag_list, :multiple => true
    time :created_at
    time :updated_at
    string :sort_name do
      name.downcase.gsub(/^(an?|the)/, '')
    end
  end

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
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name: auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         email: auth.info.email,
                         password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name: auth.extra.raw_info.name,
                         provider: auth.provider,
                         uid: auth.uid,
                         bio: auth.info.description,
                         remote_avatar_url: auth.extra.raw_info.profile_image_url.to_s.gsub("_normal", ""),
                         email: auth.extra.raw_info.screen_name + '@personlog.com',
                         password: Devise.friendly_token[0, 20],
                         confirmed_at: Time.now
      )
    end
    user
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
      user = User.create(name: data["name"],
                         email: data["email"],
                         password: Devise.friendly_token[0, 20]
      )
    end
    user
  end

end
