class Feedback < ApplicationRecord
    belongs_to :request

    validates :observations, presence: true
    validates :satisfaction, presence: true
    validates :request_id, presence: true
end
