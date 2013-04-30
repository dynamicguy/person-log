# == Schema Information
#
# Table name: authentications
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  provider    :string(255)
#  uid         :string(255)
#  raw         :text
#  credentials :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Authentication < ActiveRecord::Base
  has_paper_trail
  attr_accessible :provider, :uid, :user_id, :raw, :credentials
  resourcify
  belongs_to :user

  validates_presence_of :provider, :uid

  def name
    self.provider
  end

end
