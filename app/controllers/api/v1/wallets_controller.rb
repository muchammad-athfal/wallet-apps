class Api::V1::WalletsController < ApplicationController
  before_action :set_wallet, only: [:index, :transfer]

  # GET /api/wallets
  def index
    # List all wallets for the current user
    render json: {
      status: true,
      message: 'Data Retrieved Successfully',
      data: @wallet
    }, status: :ok
  end

  # POST /api/wallets
  def create
    # Find the walletable entity (User, Team, Stock, etc.) based on the provided type and ID
    walletable = find_walletable

    if walletable.present?
      @wallet = walletable.build_wallet(wallet_params)

      if @wallet.save
        render json: {
          status: true,
          message: 'Wallet created successfully',
          data: @wallet
        }, status: :ok
      else
        render json: {
          status: false,
          message: @wallet.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: false,
        message: 'Wallet Entity not found'
      }, status: :unprocessable_entity
    end
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
    @wallet = current_user.wallet
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: false,
      message: 'Wallet not found'
    }, status: :not_found
  end

  # Method to find the walletable entity based on type and ID
  def find_walletable
    params[:walletable_type].constantize.find_by(id: params[:walletable_id])
  rescue StandardError
    nil
  end

  # Strong parameters to allow the required fields for creating a wallet
  def wallet_params
    params.permit(:balance)
  end
end
