class Request < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  before_save { self.requester_mail = requester_mail.downcase }
  validates :requester_name, presence: true
  validates :requester_extension, presence: true
  validates :requester_phone, presence: true
  validates :requester_id, presence: true
  validates :requester_mail, presence: true,
            format: { with: VALID_EMAIL_REGEX }
  validates :requester_type, presence: true
  validates :work_building, presence: true
  validates :work_location, presence: true
  validates :work_type, presence: true
  validates :work_description, presence: true
end
