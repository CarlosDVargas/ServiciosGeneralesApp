class DenyReason < ApplicationRecord
  belongs_to :user
  belongs_to :request

  attr_accessor :user_id, :request_id
end
