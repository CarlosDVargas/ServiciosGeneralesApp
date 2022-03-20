class Employee < ApplicationRecord
  has_many :tasks
  has_many :requests, through: :tasks

  has_one :user

  validates :email, :uniqueness => {message: "ya pertenece a otra cuenta"}
end
