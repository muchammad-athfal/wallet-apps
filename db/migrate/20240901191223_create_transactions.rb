class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :source_wallet, null: false, foreign_key: {to_table: :wallets}
      t.references :target_wallet, null: false, foreign_key: {to_table: :wallets}
      t.decimal :amount
      t.string :kind

      t.timestamps
    end
  end
end
