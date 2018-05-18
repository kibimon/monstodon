# frozen_string_literal: true

class Monstodon::MonBoxesController < ApplicationController
  include AccountControllerConcern

  def index
    @mon = @account.mon.order(:mon_no).page(params[:page]).per(MON_PER_PAGE)

    respond_to do |format|
      format.html do
        @relationships = AccountRelationshipsPresenter.new(@mon.map(&:id), current_user.account_id) if user_signed_in?
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
    TagManager.instance.mon_url_for(@account, page: page) unless page.nil?
  end

  def collection_presenter
    page = ActivityPub::CollectionPresenter.new(
      id: ActivityPub::TagManager.instance.mon_uri_for(@account, page: params.fetch(:page, 1)),
      type: :ordered,
      size: @account.mon.count,
      items: @mon.map { |mon| ActivityPub::TagManager.instance.uri_for(mon) },
      part_of: ActivityPub::TagManager.instance.mon_uri_for(@account),
      next: page_url(@mon.next_page),
      prev: page_url(@mon.prev_page)
    )
    if params[:page].present?
      page
    else
      ActivityPub::CollectionPresenter.new(
        id: ActivityPub::TagManager.instance.mon_uri_for(@account),
        type: :ordered,
        size: @account.mon.count,
        first: page
      )
    end
  end
end
