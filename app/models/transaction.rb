class Transaction < ApplicationRecord
  belongs_to :source_wallet, class_name: 'Wallet', optional: true
  belongs_to :target_wallet, class_name: 'Wallet', optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validate :validate_wallets

  private

  def validate_wallets
    if type == 'Credit'
      errors.add(:source_wallet, 'must be nil for credits') unless source_wallet.nil?
      errors.add(:target_wallet, 'must be present for credits') if target_wallet.nil?
    elsif type == 'Debit'
      errors.add(:source_wallet, 'must be present for debits') if source_wallet.nil?
      errors.add(:target_wallet, 'must be nil for debits') unless target_wallet.nil?
    else
      errors.add(:type, 'must be either Credit or Debit')
    end
  end
end

