class Employee < ApplicationRecord
  has_many :tasks
  has_many :requests, through: :task

  belongs_to :user, optional: true

  validates :email, :uniqueness => {message: "ya pertenece a otra cuenta"}
end
