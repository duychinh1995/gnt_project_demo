class Order < ApplicationRecord
  belongs_to :user
  belongs_to :giftcode
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details
  enum status: {Ordered: 0, Validated: 1, Shipping: 2, Received: 3, Paid: 4}
  delegate :name, :status, :phone, :email, :address, to: :user, prefix: true, allow_nil: true
end
