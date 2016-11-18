class Invite < ActiveRecord::Base
  has_one :user
  belongs_to :campaign
  validates :email, :presence => true,:uniqueness => {:case_sensitive => false},format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/, message: "Not a valid email Address" }
end
