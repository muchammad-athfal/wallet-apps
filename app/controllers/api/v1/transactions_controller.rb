class Api::V1::TransactionsController < ApplicationController
    before_action :authenticate_request
end
