# == Schema Information
#
# Table name: postal_addresses
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  description         :string(255)
#  email               :string(255)
#  url                 :string(255)
#  faxNumber           :string(255)
#  telephone           :string(255)
#  country             :string(255)
#  locality            :string(255)
#  region              :string(255)
#  postalCode          :string(255)
#  postOfficeBoxNumber :string(255)
#  street              :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class PostalAddress < ActiveRecord::Base
  has_paper_trail
  resourcify
  attr_accessible :name, :description, :email, :url, :faxNumber, :telephone, :country, :locality, :region, :postalCode, :postOfficeBoxNumber, :street
end
