class Feed < ActiveRecord::Base
  belongs_to :user
  belongs_to :campaign
  belongs_to :interest
  acts_as_likeable
  has_many :likes, :foreign_key => :likeable_id
  has_many :pledges, dependent: :destroy

  #validations

  validates :title, :presence => true
  validates :interest_id, :presence => true
  validates :short_description, :presence => true
  validates :quantity, :presence => true
  validates :start_time, :presence => true
  validates :end_time, :presence => true
  validates :date, :presence => true
  validates :location, :presence => true
end
