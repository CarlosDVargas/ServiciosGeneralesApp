class User <ApplicationRecord
  before_save { self.email = email.downcase }
  validates :username, presence: true, 
                        uniqueness: { case_sensitive: false }, 
                        length: { minimum: 3, maximum: 25 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false }, 
                    length: { maximum: 75 },
                    format: { with: VALID_EMAIL_REGEX }
  
  has_secure_password

  has_many :deny_reasons
  accepts_nested_attributes_for :deny_reasons, reject_if: all.blank?, allow_destroy: true
end