# frozen_string_literal: true

class AccountUnfollowController < ApplicationController
  include AccountControllerConcern

  before_action :authenticate_user!

  def create
    UnfollowService.new.call(current_user.account, @account)
    redirect_to TagManager.instance.full_url_for(@account)
  end
end
