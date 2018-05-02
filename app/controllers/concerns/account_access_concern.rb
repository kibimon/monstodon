# frozen_string_literal: true

module AccountAccessConcern
  extend ActiveSupport::Concern

  FOLLOW_PER_PAGE = 12

  included do
    layout 'public'
    before_action :set_account
    before_action :require_local!
    before_action :verify_routing_version!
    before_action :check_account_suspension
  end

  private

  # The route gives us the means of accessing the account. Only routes
  # which begin with one of the below strings point to accounts.
  def set_account
    if request.path.start_with?('/@') || request.path.start_with?('/users/')
      @account = Account.find_by_username!(params[:account_username])
      raise(ActiveRecord::RecordNotFound) unless @account.trainer?
    elsif request.path.start_with?('/Mon/')
      @account = Account.find_no!(:mon_no, params[:account_no])
    elsif request.path.start_with?('/Route/')
      @account = Account.find_no!(:route_regional_no, params[:account_no])
    elsif request.path.start_with?('/Trainer/')
      @account = Account.find_no!(:trainer_no, params[:account_no])
    else
      @account = nil
    end
  end

  def check_account_suspension
    gone if !@account.nil? && @account.suspended?
  end

  def require_local!
    raise(ActiveRecord::RecordNotFound) unless @account.nil? || @account.local?
  end

  # The old "/users/:username" route should return Not Found for newer
  # accounts, and the new "/Trainer/:numero" route should return Not
  # Found for older accounts.
  def verify_routing_version!
    return if @account.nil?
    case @account.routing_version
    when 1
      raise(ActiveRecord::RecordNotFound) if request.path.start_with?('/Mon/', '/Route/', '/Trainer/')
    else
      raise(ActiveRecord::RecordNotFound) if request.path.start_with?('/users/')
    end
  end
end
