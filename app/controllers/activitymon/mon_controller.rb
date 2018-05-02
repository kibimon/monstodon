# frozen_string_literal: true

class ActivityMon::MonController < AccountsController
  before_action :verify_type!

  private

  def verify_type!
    raise(ActiveRecord::RecordNotFound) unless @account.mon?
  end
end
