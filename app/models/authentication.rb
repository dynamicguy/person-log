class Authentication < ActiveRecord::Base
  attr_accessible :provider, :uid, :user_id, :raw, :credentials

  belongs_to :user
end
