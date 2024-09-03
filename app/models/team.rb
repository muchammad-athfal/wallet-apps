class Team < ApplicationRecord
  has_one :wallet, as: :walletable, dependent: :destroy
  after_create :create_wallet

  def wallet_balance
    wallet.balance
  end

  private
  def create_wallet
    return if wallet.present?
    Wallet.create(walletable: self)
  end
end
