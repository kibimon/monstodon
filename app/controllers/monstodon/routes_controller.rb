# frozen_string_literal: true

class Monstodon::RoutesController < AccountsController
  before_action :verify_type!

  private

  def verify_type!
    raise(ActiveRecord::RecordNotFound) unless @account.route?
  end
end
