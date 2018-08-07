class Giftcode < ApplicationRecord
  belongs_to :user
  scope :get_giftcode, ->(id){where(user_id: id)}
end
