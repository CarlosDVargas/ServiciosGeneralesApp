class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum role: [:employee, :assistant, :admin]

  after_initialize :set_default_role, :if => :new_record?

  has_many :observations

  has_many :request_actions
  has_many :requests, through: :request_actions

  def set_default_role
    self.role ||= :employee
  end
end
