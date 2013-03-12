class TransactionsController < ApplicationController

  before_filter :ensure_current_user
  before_filter :find_active_ledger

  def new
    @transaction = @ledger.transactions.new
  end

  def create
    @transaction = @ledger.transactions.create_and_recur(params[:transaction])
    redirect_to ledgers_path(@ledger)
  end

  def show
    @transaction = @ledger.transaction.find(params[:id])
  end

  def find_active_ledger
    @ledger = current_user.ledgers.find(params[:ledger_id])
  end
end
