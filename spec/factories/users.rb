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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password 'please'
    password_confirmation 'please'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
  end
end
