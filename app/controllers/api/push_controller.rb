# frozen_string_literal: true

class Api::PushController < Api::BaseController
  include SignatureVerification

  def update
    response, status = process_push_request
    render plain: response, status: status
  end

  private

  def process_push_request
    case hub_mode
    when 'subscribe'
      Pubsubhubbub::SubscribeService.new.call(account_from_topic, hub_callback, hub_secret, hub_lease_seconds, verified_domain)
    when 'unsubscribe'
      Pubsubhubbub::UnsubscribeService.new.call(account_from_topic, hub_callback)
    else
      ["Unknown mode: #{hub_mode}", 422]
    end
  end

  def hub_mode
    params['hub.mode']
  end

  def hub_topic
    params['hub.topic']
  end

  def hub_callback
    params['hub.callback']
  end

  def hub_lease_seconds
    params['hub.lease_seconds']
  end

  def hub_secret
    params['hub.secret']
  end

  def account_from_topic
    if hub_topic.present? && local_uri? && account_feed_path?
      ActivityPub::TagManager.instance.uri_to_account(hub_topic, Account)
    end
  end

  def local_uri?
    ActivityPub::TagManager.instance.local_uri? hub_topic
  end

  def verified_domain
    return signed_request_account.domain if signed_request_account
  end

  def account_feed_path?
    uri = Addressable::URI.parse(hub_topic)
    route = Rails.application.routes.recognize_path(uri.path)
    %w(activitymon/trainers activitymon/routes activitymon/mon).include?(route[:controller]) &&
      route[:action] == 'show' &&
      route[:format] == 'atom'
  end
end
