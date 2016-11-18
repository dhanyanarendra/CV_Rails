class Interest < ActiveRecord::Base
  has_many :feeds
  validates :name, :presence => true
end
