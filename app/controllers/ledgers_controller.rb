class LedgersController < ApplicationController

  before_filter :ensure_current_user

  def index
    @ledgers = current_user.ledgers
  end

  def new
    @ledger = current_user.ledgers.new
  end

  def create
    @ledger = current_user.ledgers.create(params[:ledger])
    redirect_to ledgers_path(@ledger)
  end

  def show
    @ledger = current_user.ledgers.find(params[:id])
  end

end
