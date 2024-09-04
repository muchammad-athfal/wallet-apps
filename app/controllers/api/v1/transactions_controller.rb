class Api::V1::TransactionsController < ApplicationController
  before_action :set_wallet, only: [:index, :create]

  # GET /api/wallets/:wallet_id/transactions
  def index
    source_transactions = @wallet.source_transactions
    target_transactions = @wallet.target_transactions
    
    @transactions = source_transactions.or(target_transactions).order(created_at: :desc)
    render json: {
      status: true,
      message: 'Data Retrieved Successfully',
      data: @transactions
    }, status: :ok
  end

  # POST /api/wallets/:wallet_id/transactions
  def create
    target_wallet = Wallet.find_by(id: transaction_params[:target_wallet_id])
    amount = transaction_params[:amount].to_f

    ApplicationRecord.transaction do
      case transaction_params[:type]
      when 'Credit'
        if target_wallet && @wallet == nil
          @wallet.increment!(:balance, amount)
          Transaction.create!(
            source_wallet: nil,
            target_wallet: @wallet,
            amount: amount,
            type: 'Credit'
          )
        else
          render json: {
            status: false,
            message: 'Invalid credit transaction'
          }, status: :unprocessable_entity
          return
        end
      when 'Debit'
        if @wallet.balance >= amount && target_wallet
          @wallet.decrement!(:balance, amount)
          target_wallet.increment!(:balance, amount)

          Transaction.create!(
            source_wallet: @wallet,
            target_wallet: nil,
            amount: amount,
            type: 'Debit'
          )
        else
          render json: {
            status: false,
            message: 'Insufficient funds or invalid target wallet'
          }, status: :unprocessable_entity
          return
        end
      else
        render json: {
          status: false,
          message: 'Invalid transaction type'
        }, status: :unprocessable_entity
        return
      end
    end

    render json: {
      status: true, 
      message: 'Transaction successful'
    }, status: :created
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

  def transaction_params
    params.permit(:amount, :target_wallet_id, :type)
  end
  
end
