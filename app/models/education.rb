# == Schema Information
#
# Table name: educations
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  school         :string(255)
#  etype          :string(255)
#  year           :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  degree         :string(127)
#  field_of_study :string(127)
#  start_date     :date
#  end_date       :date
#

class Education < ActiveRecord::Base
  attr_accessible :school, :degree, :field_of_study, :start_date, :end_date, :user_id, :user
  belongs_to :user
  has_paper_trail
  resourcify
  validates_presence_of :school

  def name
    self.school
  end
end
