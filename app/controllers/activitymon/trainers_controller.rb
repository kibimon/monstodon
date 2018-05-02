# frozen_string_literal: true

class ActivityMon::TrainersController < AccountsController

  def set_account
    if !params[:username].blank?
      @account = Account.find_by_username!(params[:username])
    else
      @account = Account.find_no!(:trainer_no, params[:numero])
    end
  end
end
