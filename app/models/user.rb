class User < ApplicationRecord
  has_many :wallets, as: :walletable, dependent: :destroy
  has_secure_password

  validates :email, presence: true, uniqueness: true
end
