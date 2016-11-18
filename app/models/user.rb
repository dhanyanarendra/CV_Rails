class User < ActiveRecord::Base
  rolify

  has_secure_password
  belongs_to :campaign
  belongs_to :invite
  has_many :feeds
  acts_as_liker
  has_many :user_issues
  has_many :issues, through: :user_issues
  has_many :pledges, :foreign_key => :user_contributor_id

  # Callbacks
  before_validation :generate_auth_token,on: :create
  before_validation :downcase_email

  # Constants
  EXCLUDED_JSON_ATTRIBUTES = [:password_digest, :created_at, :updated_at]

  #validations
  validates :email, :presence => true,:uniqueness => {:case_sensitive => true},format: { with: /\A([^@\s]+)@((?:[A-Za-z0-9]+\.)+[A-Za-z]{2,})\z/, message: "Not a valid email Address" }
  validates :password, :presence => true, length: {minimum: 8},:allow_nil => true, :unless => lambda {|u| u.password.nil? }


  def downcase_email
    self.email = self.email.downcase if self.email.present?
  end

  #image upload
  mount_uploader :file, AvatarUploader

  def generate_auth_token
    begin
      self.auth_token = SecureRandom.hex
    end while self.class.exists?(auth_token: auth_token)
  end

  def generate_password_reset_token
    begin
      self.password_reset_token = SecureRandom.urlsafe_base64
      self.password_reset_sent_at = Time.current
      save(validate: false)
    end
  end
end
