# frozen_string_literal: true

require 'singleton'

class ActivityPub::TagManager
  include Singleton
  include RoutingHelper

  CONTEXT = 'https://www.w3.org/ns/activitystreams'

  COLLECTIONS = {
    public: 'https://www.w3.org/ns/activitystreams#Public',
  }.freeze

  def uri_for(target, *more)
    return target.uri if target.respond_to?(:local?) && !target.local?

    case target.object_type
    when :mon, :route, :trainer
      account_url(target, *more)
    when :note, :comment, :activity
      return activity_account_status_url(target.account, target, *more) if target.reblog?
      account_status_url(target.account, target, *more)
    when :emoji
      emoji_url(target, *more)
    end
  end

  def activity_uri_for(target, *more)
    raise ArgumentError, 'target must be a local activity' unless %i(note comment activity).include?(target.object_type) && target.local?

    activity_account_status_url(target.account, target, *more)
  end

  def collection_uri_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_collection_url(target, *more)
  end

  def outbox_uri_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_outbox_url(target, *more)
  end

  def inbox_uri_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_inbox_url(target, *more)
  end

  def followers_uri_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_followers_url(target, *more)
  end

  def following_uri_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_following_index_url(target, *more)
  end

  # Primary audience of a status
  # Public statuses go out to primarily the public collection
  # Unlisted and private statuses go out primarily to the followers collection
  # Others go out only to the people they mention
  def to(status)
    case status.visibility
    when 'public'
      [COLLECTIONS[:public]]
    when 'unlisted', 'private'
      [account_followers_url(status.account)]
    when 'direct'
      status.mentions.map { |mention| uri_for(mention.account) }
    end
  end

  # Secondary audience of a status
  # Public statuses go out to followers as well
  # Unlisted statuses go to the public as well
  # Both of those and private statuses also go to the people mentioned in them
  # Direct ones don't have a secondary audience
  def cc(status)
    cc = []

    cc << uri_for(status.reblog.account) if status.reblog?

    case status.visibility
    when 'public'
      cc << account_followers_url(status.account)
    when 'unlisted'
      cc << COLLECTIONS[:public]
    end

    cc.concat(status.mentions.map { |mention| uri_for(mention.account) }) unless status.direct_visibility?

    cc
  end

  def local_uri?(uri)
    uri  = Addressable::URI.parse(uri)
    host = uri.normalized_host
    host = "#{host}:#{uri.port}" if uri.port

    !host.nil? && (::TagManager.instance.local_domain?(host) || ::TagManager.instance.web_domain?(host))
  end

  def uri_to_local_id(uri, param = :id)
    path_params = Rails.application.routes.recognize_path(uri)
    path_params[param]
  end

  def uri_to_account(uri, klass)
    path_params = Rails.application.routes.recognize_path(uri)
    return nil unless %w(accounts activitymon/mon activitymon/routes activitymon/trainers).include? path_params[:controller]
    case path_params[:type]
    when 'mon'
      klass.find_no(:mon_no, path_params[:numero])
    when 'route'
      klass.find_no(:route_regional_no, path_params[:numero])
    when 'trainer'
      account = klass.find_no(:trainer_no, path_params[:numero])
      return nil if account.nil? || account.routing_version == 1
      account
    when 'short_trainer'
      klass.find_by_username(path_params[:username])
    when 'v1_trainer'
      account = klass.find_by_username(path_params[:username])
      return nil if account.nil? || account.routing_version != 1
      account
    end
  end

  def uri_to_resource(uri, klass)
    if local_uri?(uri)
      case klass.name
      when 'Account'
        uri_to_account(uri, klass)
      else
        StatusFinder.new(uri).status
      end
    elsif OStatus::TagManager.instance.local_id?(uri)
      klass.find_by(id: OStatus::TagManager.instance.unique_tag_to_local_id(uri, klass.to_s))
    else
      klass.find_by(uri: uri.split('#').first)
    end
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
