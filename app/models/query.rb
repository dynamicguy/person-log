# == Schema Information
#
# Table name: queries
#
#  id         :integer          not null, primary key
#  q          :string(255)
#  user_id    :integer
#  ua         :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  ip         :string(255)
#

class Query < ActiveRecord::Base
  attr_accessible :q, :ua, :user_id, :ip
  belongs_to :user
  validates_presence_of :user_id
  paginates_per 10
  resourcify
  def self.search(search)
    if search
      where('q LIKE ?', "%#{search}%")
    else
      scoped
    end
  end

end
