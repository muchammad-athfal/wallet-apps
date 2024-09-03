class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validate :validate_wallets

  after_create :update_wallet_balances

  private

  def validate_wallets
    if kind == 'credit'
      errors.add(:source_wallet, "must be present for credits") if source_wallet.nil?
      errors.add(:target_wallet, "should be nil for credits") if target_wallet.present?
    elsif kind == 'debit'
      errors.add(:source_wallet, "should be nil for debits") if source_wallet.present?
      errors.add(:target_wallet, "must be present for debits") if target_wallet.nil?
    else
      errors.add(:kind, "must be either 'credit' or 'debit'")
    end
  end

  def update_wallet_balances
    ActiveRecord::Base.transaction do
      if kind == 'credit'
        source_wallet.withdraw(amount) if source_wallet
      elsif kind == 'debit'
        target_wallet.deposit(amount) if target_wallet
      end
    end
  end
end
