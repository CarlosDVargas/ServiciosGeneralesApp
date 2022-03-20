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

  has_many :deny_reasons, dependent: :destroy
  accepts_nested_attributes_for :deny_reasons, allow_destroy: true, reject_if: proc { |attr| attr["description"].blank? }

  has_many :tasks
  has_many :employees, through: :tasks
  has_many :feedbacks
end
