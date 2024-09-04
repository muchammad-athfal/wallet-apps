class User < ApplicationRecord
  has_one :wallet, as: :walletable, dependent: :destroy
  has_secure_password

  validates :email, presence: true, uniqueness: true
end
