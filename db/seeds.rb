# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Users
user1 = User.create!(
  email: 'user1@example.com',
  password: 'password123'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'password456'
)

# Create Teams
team1 = Team.create!(
  name: 'Development Team'
)

team2 = Team.create!(
  name: 'Marketing Team'
)

# Create Stocks
stock1 = Stock.create!(
  symbol: 'AAPL'
)

stock2 = Stock.create!(
  symbol: 'GOOGL'
)

# Create Wallets for Users
user1_wallet = Wallet.create!(
  walletable: user1,
  balance: 1000.0
)

user2_wallet = Wallet.create!(
  walletable: user2,
  balance: 500.0
)

# Create Wallets for Teams
team1_wallet = Wallet.create!(
  walletable: team1,
  balance: 2000.0
)

team2_wallet = Wallet.create!(
  walletable: team2,
  balance: 1500.0
)

# Create Wallets for Stocks
stock1_wallet = Wallet.create!(
  walletable: stock1,
  balance: 3000.0
)

stock2_wallet = Wallet.create!(
  walletable: stock2,
  balance: 2500.0
)

# Optional: Create some example transactions
Transaction.create!(
  source_wallet: user1_wallet,
  target_wallet: team1_wallet,
  amount: 100.0,
  kind: 'debit'
)

Transaction.create!(
  source_wallet: team2_wallet,
  target_wallet: stock1_wallet,
  amount: 200.0,
  kind: 'debit'
)

puts "Seed data created!"
