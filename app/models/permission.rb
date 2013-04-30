class Permission < ActiveRecord::Base
  belongs_to :role
  attr_accessible :action, :subject_class, :subject_id, :role_id

  validates_presence_of :action, :subject_class, :role_id
  resourcify
end
