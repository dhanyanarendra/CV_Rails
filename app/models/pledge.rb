class Pledge < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user, :class_name => 'User', :foreign_key => :user_contributor_id
end
