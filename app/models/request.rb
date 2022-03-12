class Request < ApplicationRecord
  validates :bill_of_lading, :scac, presence: true
  validates :bill_of_lading, uniqueness: { scope: :scac, message: "and scac request already exists" }
end
