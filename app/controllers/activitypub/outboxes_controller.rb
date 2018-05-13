# frozen_string_literal: true

class ActivityPub::OutboxesController < Api::BaseController
  include AccountAccessConcern
  include SignatureVerification

  def show
    @statuses = @account.statuses.permitted_for(@account, signed_request_account).paginate_by_max_id(20, params[:max_id], params[:since_id])
    @statuses = cache_collection(@statuses, Status)

    render json: outbox_presenter, serializer: ActivityPub::OutboxSerializer, adapter: ActivityPub::Adapter, content_type: 'application/activity+json'
  end

  private

  def outbox_presenter
    ActivityPub::CollectionPresenter.new(
      id: ActivityPub::TagManager.instance.outbox_uri_for(@account),
      type: :ordered,
      size: @account.statuses_count,
      items: @statuses
    )
  end
end
