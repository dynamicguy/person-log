class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :info, :credentials

  belongs_to :user
end
