class Issue < ActiveRecord::Base
  has_many :user_issues
  has_many :user, through: :user_issues
  validates :name, :presence => true
end
