class Team < ApplicationRecord
  has_one :wallet, as: :walletable, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
