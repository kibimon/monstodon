# frozen_string_literal: true

class FollowingAccountsController < ApplicationController
  include AccountControllerConcern

  def index
    @follows = Follow.where(account: @account).recent.page(params[:page]).per(FOLLOW_PER_PAGE).preload(:target_account)

    respond_to do |format|
      format.html do
        @relationships = AccountRelationshipsPresenter.new(@follows.map(&:target_account_id), current_user.account_id) if user_signed_in?
      end

      format.json do
        render json: collection_presenter,
               serializer: ActivityPub::CollectionSerializer,
               adapter: ActivityPub::Adapter,
               content_type: 'application/activity+json'
      end
    end
  end

  private

  def page_url(page)
    TagManager.instance.following_url_for(@account, page: page) unless page.nil?
  end

  def collection_presenter
    page = ActivityPub::CollectionPresenter.new(
      id: ActivityPub::TagManager.instance.following_uri_for(@account, page: params.fetch(:page, 1)),
      type: :ordered,
      size: @account.following_count,
      items: @follows.map { |f| ActivityPub::TagManager.instance.uri_for(f.target_account) },
      part_of: ActivityPub::TagManager.instance.following_uri_for(@account),
      next: page_url(@follows.next_page),
      prev: page_url(@follows.prev_page)
    )
    if params[:page].present?
      page
    else
      ActivityPub::CollectionPresenter.new(
        id: ActivityPub::TagManager.instance.following_uri_for(@account),
        type: :ordered,
        size: @account.following_count,
        first: page
      )
    end
  end
end
