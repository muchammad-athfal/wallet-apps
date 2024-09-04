class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets do |t|
      t.references :walletable, polymorphic: true, null: false, index: true
      t.decimal :balance, default: 0.0, null: false, precision: 15, scale: 2

      t.timestamps
    end
  end
end
