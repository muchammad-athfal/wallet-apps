# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Transaction.delete_all
Wallet.delete_all
User.delete_all
Team.delete_all
Stock.delete_all

# Create Users
user1 = User.create!(name: 'User 1',email: 'user1@example.com', password: 'password')
user2 = User.create!(name: 'User 2',email: 'user2@example.com', password: 'password')
user3 = User.create!(name: 'User 3',email: 'user3@example.com', password: 'password')

# Create Wallets for Users
wallet1 = Wallet.create!(walletable: user1, balance: 1000.00)
wallet2 = Wallet.create!(walletable: user2, balance: 500.00)
wallet3 = Wallet.create!(walletable: user3, balance: 2000.00)

# Create Teams and Wallets for Teams (Optional)
team1 = Team.create!(name: 'Team A')
team2 = Team.create!(name: 'Team B')

team_wallet1 = Wallet.create!(walletable: team1, balance: 3000.00)
team_wallet2 = Wallet.create!(walletable: team2, balance: 1500.00)

# Create Stocks and Wallets for Stocks (Optional)
stock1 = Stock.create!(name: 'Stock X')
stock2 = Stock.create!(name: 'Stock Y')

stock_wallet1 = Wallet.create!(walletable: stock1, balance: 10000.00)
stock_wallet2 = Wallet.create!(walletable: stock2, balance: 20000.00)

# Create Transactions (Credits and Debits)
# Adjusting for validation rules: Credit transactions should have a nil source_wallet

# Crediting wallet2 with 200 without a specific source (e.g., external deposit)
Transaction.create!(amount: 200.00, target_wallet: wallet2, source_wallet: nil, type: 'Credit')

# Crediting wallet3 with 50 without a specific source (e.g., external deposit)
Transaction.create!(amount: 50.00, target_wallet: wallet3, source_wallet: nil, type: 'Credit')

# Crediting wallet1 with 300 without a specific source (e.g., external deposit)
Transaction.create!(amount: 300.00, target_wallet: wallet1, source_wallet: nil, type: 'Credit')

# Debiting wallet1 with 100, moving funds to wallet2
Transaction.create!(amount: 100.00, source_wallet: wallet1, target_wallet: nil, type: 'Debit')

# Optional: Transactions between different entity types
# Debiting team_wallet1 with 500, moving funds to stock_wallet1
Transaction.create!(amount: 500.00, source_wallet: team_wallet1, target_wallet: nil, type: 'Debit')

# Crediting team_wallet2 with 400 without a specific source (e.g., external deposit)
Transaction.create!(amount: 400.00, target_wallet: team_wallet2, source_wallet: nil, type: 'Credit')

puts "Seeding completed!"
