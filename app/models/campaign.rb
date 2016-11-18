class Campaign < ActiveRecord::Base
  belongs_to :user, :foreign_key => :creator_id
  has_many :feeds, dependent: :destroy
  has_many :users

  #validations
  validates :candidate_name, :presence => true
  validates :district, :presence => true
  validates :year, :presence => true
  validates :state, :presence => true
  validates :election, :presence => true
end
