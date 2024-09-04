class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, foreign_key: {to_table: :wallets}, index: true
      t.references :target_wallet, foreign_key: {to_table: :wallets}, index: true
      t.decimal :amount
      t.string :type, null: false

      t.timestamps
    end
  end
end
