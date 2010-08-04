class User < ActiveRecord::Base
  include Authentication

  validates_uniqueness_of    :identity_url
  validates_presence_of      :identity_url

  attr_accessible :identity_url

  has_many :datasets
  has_many :client_applications
  has_many :tokens, :class_name=>"OauthToken",:order=>"authorized_at desc",:include=>[:client_application]

end
