class Gallery < ActiveRecord::Base
  has_many :images
  belongs_to :user
  attr_accessible :description, :name, :user_id
end