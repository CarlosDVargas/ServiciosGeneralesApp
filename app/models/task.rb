class Task < ApplicationRecord
  belongs_to :employee
  belongs_to :request

  has_many :observations, dependent: :delete_all
end
