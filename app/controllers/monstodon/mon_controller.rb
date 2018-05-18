# frozen_string_literal: true

class Monstodon::MonController < AccountsController
  before_action :verify_type!

  protected

  def serializer_class
    Monstodon::ActivityStreams::MonSerializer
  end

  private

  def verify_type!
    raise(ActiveRecord::RecordNotFound) unless @account.mon?
  end
end
