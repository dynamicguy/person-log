# == Schema Information
#
# Table name: companies
#
#  id          :integer          not null, primary key
#  industry    :string(255)
#  name        :string(255)
#  description :text
#  location    :string(255)
#  size        :string(255)
#  ctype       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Company < ActiveRecord::Base
  has_many :positions
  attr_accessible :id, :industry, :name, :size, :ctype, :positions, :location, :description, :position_ids
  has_paper_trail
  resourcify
  validates :name, :presence => true

end
