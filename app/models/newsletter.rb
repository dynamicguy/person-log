# == Schema Information
#
# Table name: newsletters
#
#  id           :integer          not null, primary key
#  subject      :string(255)
#  delivered_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Newsletter < ActiveRecord::Base
  has_paper_trail
  attr_accessible :delivered_at, :subject
  resourcify
  validates_presence_of :subject

  def self.deliver(id)
    newsletter = find(id)
    # raise "Oops"
    sleep 30 # simulate long newsletter delivery
    newsletter.update_attribute(:delivered_at, Time.zone.now)
  end
end
