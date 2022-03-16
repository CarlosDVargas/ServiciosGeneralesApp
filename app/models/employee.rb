class Employee < ApplicationRecord
  has_many :tasks
  has_many :requests, through: :task
end
