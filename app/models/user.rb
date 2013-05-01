# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default("")
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)
#  avatar                 :string(255)
#  bio                    :text
#  gender                 :string(50)       default("male")
#  phone                  :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  invitation_token       :string(60)
#  password_salt          :string(60)
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string(255)
#  published              :boolean          default(FALSE)
#  featured               :boolean          default(FALSE)
#  published_at           :datetime
#  birthday               :date
#  deathday               :date
#  birthplace             :string(255)
#  lat                    :decimal(8, 5)    default(0.0)
#  lon                    :decimal(8, 5)    default(0.0)
#  address                :string(255)
#  marital_status         :string(255)      default("single")
#  opt_in                 :boolean          default(FALSE)
#  profile_id             :integer
#

class User < ActiveRecord::Base
  rolify
  mount_uploader :avatar, AvatarUploader
  paginates_per 22

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :invitable, :omniauthable, :omniauth_providers => [:twitter, :facebook, :google_oauth2, :github, :linkedin]

  # Setup accessible (or protected) attributes for your model
  attr_protected :role_ids, :as => :admin
  attr_accessible :id, :name, :email, :password, :password_confirmation, :remember_me, :opt_in
  attr_accessible :tag_list, :avatar, :avatar_cache, :remove_avatar, :remote_avatar_url, :confirmed_at
  attr_accessible :provider, :uid, :bio, :gender, :phone, :urls, :published, :published_at, :featured
  attr_accessible :lat, :lon, :birthday, :birthplace, :deathday, :address, :marital_status

  #validates_inclusion_of :marital_status, :in => [:single, :married, :separated, :widowed, :divorced, "declined to state"]

  acts_as_taggable
  has_many :authentications, :dependent => :destroy
  has_many :urls
  has_many :positions
  has_many :educations
  has_many :queries
  has_many :galleries

  has_and_belongs_to_many :friends,
                          :class_name => "User",
                          :association_foreign_key => "friend_id",
                          :join_table => "users_friends", :uniq => true

  has_paper_trail :only => [:name, :email, :password, :bio, :gender, :address, :phone], :on => [:update, :destroy]

  default_scope order('created_at ASC')
  scope :by_join_date, order("updated_at DESC")
  scope :active, where("confirmed_at IS NOT NULL")

  acts_as_gmappable :lat => :lat, :lng => :lon, :process_geocoding => :geocode?,
                    :address => "address", :normalized_address => "address",
                    :msg => "Sorry, not even Google could figure out where that is"

  def geocode?
    (!address.blank? && (lat.blank? || lon.blank?)) || address_changed?
  end

  def latitude
    self.lat
  end

  def longitude
    self.lon
  end

  def gmaps
    true
  end

  def gmaps4rails_address
    self.address
  end

  def gmaps4rails_title
    "#{self.id}"
  end

  def gmaps4rails_infowindow
    [
        '<div class="thumbnail" style="border:none;">',
        "<a class=\"pull-left\" href=\"/persons/#{self.id.to_s}\">",
        "<img src=\"#{self.avatar.thumb}\">",
        '</a>',
        '<div class="caption" style="width:200px;">',
        "<strong><a href=\"/persons/#{self.id.to_s}\">#{self.name}</a></strong>",
        "<div class=\"desc\">#{self.address}</div>",
        '</div>',
        '</div>'
    ].join(' ')
  end

  searchable do
    integer :id
    text :bio, :more_like_this => true
    text :name, :more_like_this => true
    string :name
    string :address
    string :email
    string :gender
    string :tag_list, :multiple => true
    boolean :published
    time :published_at
    time :created_at
    integer :sign_in_count
    latlon(:location) { Sunspot::Util::Coordinates.new(lat, lon) }
    string :sort_name do
      name.downcase.gsub(/^(an?|the)/, '') if name.present?
    end
  end

  has_many :invitations, :class_name => self.class.to_s, :as => :invited_by

  validates_confirmation_of :password

  def dead
    true
  end

  def location
    [lat, lon]
  end

  def password_required?
    if !persisted?
      !(password != "")
    else
      !password.nil? || !password_confirmation.nil?
    end
  end

# override Devise method
  def confirmation_required?
    false
  end

# override Devise method
  def active_for_authentication?
    confirmed? || confirmation_period_valid?
  end

# new function to set the password
  def attempt_set_password(params)
    p = {}
    p[:password] = params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end

# new function to determine whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end

# new function to provide access to protected method pending_any_confirmation
  def only_if_unconfirmed
    pending_any_confirmation { yield }
  end

  validates :email, :presence => true

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    if signed_in_resource
      user = User.find(signed_in_resource.id)
    else
      user = User.where(:email => auth.info.email).first
      unless user
        user = create_user_from_facebook_oauth(auth)
      end
    end
    user
  end

  def self.create_user_from_facebook_oauth(auth)
    user = User.create(name: auth.info.name,
                       provider: auth.provider,
                       uid: auth.uid,
                       email: auth.info.email,
                       bio: auth.info.description || auth.extra.raw_info.quotes,
                       remote_avatar_url: auth.info.image.to_s.gsub("square", "large"),
                       password: Devise.friendly_token[0, 20],
                       phone: auth.info.phone,
                       address: auth.info.location,
                       gender: auth.extra.raw_info.gender,
                       confirmed_at: Time.now
    )

    if auth.extra.raw_info.link
      user.urls.create(:title => auth.provider, :value => auth.extra.raw_info.link)
    end
    if auth.extra.raw_info.work
      auth.extra.raw_info.work.each do |w|
        c = Company.find_or_create_by_name(
            :name => w.employer.name,
            :description => w.description
        )
        if w.location
          c.location = w.location['name']
          c.save
        end
        if w.start_date.present?
          sd = Date.new(w.start_date.split('-').first.to_i, w.start_date.split('-').last.to_i, 1)
        else
          sd = Date.today
        end
        if w.position.present?
          position = Position.find_or_create_by_id(
              :id => w.position.id.to_i,
              :start_date => sd,
              :company_id => c.id,
              :user_id => user.id
          )
          if w.position.name
            position.name = w.position.name
            position.save
          end
        end
      end
    end
    if auth.extra.raw_info.education.present?
      auth.extra.raw_info.education.each do |education|
        edu = Education.find_or_create_by_school_and_degree_and_user_id(school: education.school.name, degree: education.type, user_id: user.id)
        if education.year.present?
          edu.start_date = Date.new(education.year.name.to_i, 1, 1)
          edu.save
        end
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
                           address: auth.info.location,
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
                           address: auth.extra.raw_info.location,
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
                           address: auth.extra.raw_info.location || '',
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

  def self.import_linkedin_connections(user, result)
    if result
      result.all.each do |linked_in_profile|
        if linked_in_profile.present?
          usr = User.find_or_create_by_uid(
              :uid => linked_in_profile.id,
              :provider => 'linkedin',
              :bio => [linked_in_profile.headline, linked_in_profile.industry].join(', '),
              :email => [linked_in_profile.first_name.parameterize, linked_in_profile.last_name.parameterize, Devise.friendly_token[0, 20]].join('.') +'@personlog.com',
              :password => Devise.friendly_token[0, 20],
              :remote_avatar_url => linked_in_profile.picture_url,
              :name => [linked_in_profile.first_name, linked_in_profile.last_name].join(' '),
              :confirmed_at => Time.now,
              :published => true,
              :published_at => Time.now
          )
          if linked_in_profile.location
            usr.address = linked_in_profile.location.name
          end
          usr.friends << user
          usr.save
          user.friends << usr
          if linked_in_profile.public_profile_url
            usr.urls.create(:title => 'linkedin', :value => linked_in_profile.public_profile_url)
          end
          import_positions_from_linkedin(linked_in_profile, usr)
          import_educations_from_linkedin(linked_in_profile, usr)
        end #if u.present ends here
      end #result ends
    end
  end

  def self.import_educations_from_linkedin(linked_in_profile, usr)
    if linked_in_profile.educations
      linked_in_profile.educations.all.each do |education|
        Education.find_or_create_by_school_and_degree_and_user_id(:school => education.school_name, :degree => education.degree, :user_id => usr.id).tap do |edu|
          if education.start_date.present?
            if education.start_date.year.present?
              edu.start_date = Date.new(education.start_date.year, 1, 1)
            end
          end
          if education.end_date.present?
            if education.end_date.year.present?
              edu.end_date = Date.new(education.end_date.year, 1, 1)
            end
          end
          edu.field_of_study = education.field_of_study if education.field_of_study.present?
        end.save
      end
    end
  end

  def self.import_positions_from_linkedin(linked_in_profile, usr)
    if linked_in_profile.positions.present?
      if linked_in_profile.positions.all.present?
        linked_in_profile.positions.all.each do |p|
          c = Company.find_or_initialize_by_industry_and_name_and_ctype(:industry => p.company.industry, :name => p.company.name, :ctype => p.company.type)
          c.size = p.company.size if p.company.size.present?
          c.save
          if p.start_date.present?
            if p.start_date.year.present? && p.start_date.month.present?
              sd = Date.new(p.start_date.year, p.start_date.month, 1)
            else
              sd = Date.today
            end
          else
            sd = Date.today
          end
          Position.find_or_create_by_name_and_company_id_and_user_id(:name => p.title, :company_id => c.id, :user_id => usr.id).tap do |position|
            position.is_current = p.is_current
            position.summary = p.summary
            position.start_date = sd
          end.save
        end
      end
    end
  end

  def self.not_in?(current_user, provider)
    current_user.authentications.where(:provider => provider).length == 0
  end

end
