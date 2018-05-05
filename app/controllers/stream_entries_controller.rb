# frozen_string_literal: true

class StreamEntriesController < ApplicationController
  include Authorization
  include SignatureVerification
  include AccountAccessConcern

  layout 'public'

  before_action :set_stream_entry
  before_action :set_link_headers
  before_action :set_cache_headers

  def show
    respond_to do |format|
      format.html do
        redirect_to TagManager.instance.url_for(@stream_entry.activity) if @type == 'status'
      end

      format.atom do
        unless @stream_entry.hidden?
          skip_session!
          expires_in 3.minutes, public: true
        end
        render xml: OStatus::AtomSerializer.render(OStatus::AtomSerializer.new.entry(@stream_entry, true))
      end
    end
  end

  def embed
    redirect_to TagManager.instance.embed_url_for(@stream_entry.activity), status: 301
  end

  private

  def set_link_headers
    response.headers['Link'] = LinkHeader.new(
      [
        [TagManager.instance.url_for(@stream_entry, format: 'atom'), [%w(rel alternate), %w(type application/atom+xml)]],
        [ActivityPub::TagManager.instance.uri_for(@stream_entry.activity), [%w(rel alternate), %w(type application/activity+json)]],
      ]
    )
  end

  def set_stream_entry
    @stream_entry = @account.stream_entries.where(activity_type: 'Status').find(params[:id])
    @type         = @stream_entry.activity_type.downcase

    raise ActiveRecord::RecordNotFound if @stream_entry.activity.nil?
    authorize @stream_entry.activity, :show? if @stream_entry.hidden?
  rescue Mastodon::NotPermittedError
    # Reraise in order to get a 404
    raise ActiveRecord::RecordNotFound
  end
end
