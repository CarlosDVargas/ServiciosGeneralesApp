class Employee < ApplicationRecord
  has_many :tasks
  has_many :requests, through: :task

  has_one :user

  validates :email, :uniqueness => {message: "ya pertenece a otra cuenta"}
end
