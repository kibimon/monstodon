# frozen_string_literal: true

class Monstodon::TrainersController < AccountsController
  before_action :verify_type!

  private

  def verify_type!
    raise(ActiveRecord::RecordNotFound) unless @account.trainer?
  end
end
