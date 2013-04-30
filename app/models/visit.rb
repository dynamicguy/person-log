# == Schema Information
#
# Table name: visits
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ip         :string(255)
#  ua         :string(255)
#  created    :datetime
#  visitor_id :integer
#

class Visit < ActiveRecord::Base
  belongs_to :user
  attr_accessible :created, :ip, :ua, :user_id, :visitor_id
  paginates_per 22
  resourcify
  default_scope order('created DESC')

  before_save :init_data

  def init_data
    self.created ||= DateTime.now if new_record?
  end
end
