class PostalAddress < ActiveRecord::Base

  attr_accessible :name, :description, :email, :url, :faxNumber, :telephone, :country, :locality, :region, :postalCode, :postOfficeBoxNumber, :street
end