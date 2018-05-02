# frozen_string_literal: true

class ActivityMon::MonController < AccountsController
  def set_account
    @account = Account.find_no!(:mon_no, params[:numero])
  end
end
