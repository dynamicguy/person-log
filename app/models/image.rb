class Image < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  belongs_to :gallery
  attr_accessible :name, :description, :image, :image_cache, :gallery_id

  validates_presence_of :name, :gallery_id, :image
end
