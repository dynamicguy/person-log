# == Schema Information
#
# Table name: urls
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  value      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Url < ActiveRecord::Base
  belongs_to :user
  has_paper_trail
  attr_accessible :title, :user_id, :value
  resourcify
  validates_presence_of :title, :value, :user_id
  validates_uniqueness_of :title, :scope => [:title, :user_id]
end
