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

  def route_type
    params[:account_type]
  end

  def username
    params[:account_username]
  end

  def numero
    params[:account_no]
  end

  # The route gives us the means of accessing the account.
  def set_account
    if %w(short_trainer v1_trainer).include? route_type
      @account = Account.find_by_username!(username)
      raise(ActiveRecord::RecordNotFound) unless @account.trainer?
    elsif route_type == 'mon'
      @account = Account.find_no!(:mon_no, numero)
    elsif route_type == 'route'
      @account = Account.find_no!(:route_no, numero)
    elsif route_type == 'trainer'
      @account = Account.find_no!(:trainer_no, numero)
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
      raise(ActiveRecord::RecordNotFound) unless %w(v1_trainer short_trainer).include? route_type
    else
      raise(ActiveRecord::RecordNotFound) if route_type == 'v1_trainer'
    end
  end
end
