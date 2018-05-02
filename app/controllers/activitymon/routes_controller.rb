# frozen_string_literal: true

class ActivityMon::RoutesController < AccountsController
  def set_account
    @account = Account.find_no!(:route_regional_no, params[:numero])
  end
end
