class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  enum role: [:employee, :assistant, :admin]

  after_initialize :set_default_role, :if => :new_record?

  has_many :observations

  def set_default_role
    self.role ||= :employee
  end
end
