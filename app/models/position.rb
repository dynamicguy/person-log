# == Schema Information
#
# Table name: positions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  summary    :text
#  start_date :date
#  is_current :boolean
#  company_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  end_date   :date
#

class Position < ActiveRecord::Base
  belongs_to :company
  belongs_to :user
  has_paper_trail
  attr_accessible :id, :company_id, :is_current, :start_date, :end_date, :summary, :name, :user_id
  resourcify
  validates_presence_of :name
end
