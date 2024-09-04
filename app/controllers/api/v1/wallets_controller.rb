class Api::V1::WalletsController < ApplicationController
  before_action :set_wallet, only: [:show, :transfer]

  # GET /api/wallets
  def index
    # List all wallets for the current user
    @wallets = current_user.wallets
    render json: {
      status: true,
      message: 'Data Retrieved Successfully',
      data: @wallets
    }, status: :ok
  end

  # GET /api/wallets/:id
  def show
    render json: {
      status: true,
      message: 'Data Retrieved Successfully',
      data: @wallet
    }, status: :ok
  end

  # POST /api/wallets/:id/transfer
  def transfer
    target_wallet = Wallet.find_by(id: params[:target_wallet_id])
    amount = params[:amount].to_f

    if @wallet.balance >= amount && target_wallet
      ApplicationRecord.transaction do
        @wallet.decrement!(:balance, amount)
        target_wallet.increment!(:balance, amount)

        Transaction.create!(
          source_wallet: @wallet,
          target_wallet: nil,
          amount: amount,
          type: 'Debit'
        )

        Transaction.create!(
          source_wallet: nil,
          target_wallet: target_wallet,
          amount: amount,
          type: 'Credit'
        )
      end

      render json: {
        status: true,
        message: 'Transfer successful'
      }, status: :ok
    else
      render json: {
        status: false,
        message: 'Insufficient funds or invalid target wallet'
      }, status: :unprocessable_entity
    end
  end

  private

  def set_wallet
    @wallet = current_user.wallets.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: false,
      message: 'Wallet not found'
    }, status: :not_found
  end
end
