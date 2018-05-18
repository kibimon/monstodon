# frozen_string_literal: true

require 'singleton'

class TagManager
  include Singleton
  include RoutingHelper

  def web_domain?(domain)
    domain.nil? || domain.gsub(/[\/]/, '').casecmp(Rails.configuration.x.web_domain).zero?
  end

  def local_domain?(domain)
    domain.nil? || domain.gsub(/[\/]/, '').casecmp(Rails.configuration.x.local_domain).zero?
  end

  def normalize_domain(domain)
    return if domain.nil?

    uri = Addressable::URI.new
    uri.host = domain.gsub(/[\/]/, '')
    uri.normalized_host
  end

  def same_acct?(canonical, needle)
    return true if canonical.casecmp(needle).zero?
    username, domain = needle.split('@')
    local_domain?(domain) && canonical.casecmp(username).zero?
  end

  def local_url?(url)
    uri    = Addressable::URI.parse(url).normalize
    domain = uri.host + (uri.port ? ":#{uri.port}" : '')
    TagManager.instance.web_domain?(domain)
  end

  def url_for(target, *more)
    return target.url if target.respond_to?(:local?) && !target.local?

    case target.object_type
    when :mon, :route, :trainer
      short_account_url(target, *more)
    when :note, :comment, :activity
      return account_stream_entry_url(target.account, target, *more) if target.respond_to?(:stream_entry?) && target.stream_entry?
      return activity_account_status_url(target.account, target, *more) if target.reblog?
      short_account_status_url(target.account, target, *more)
    end
  end

  def full_url_for(target, *more)
    return target.url if target.respond_to?(:local?) && !target.local?

    case target.object_type
    when :mon, :route, :trainer
      account_url(target, *more)
    when :note, :comment, :activity
      return account_stream_entry_url(target.account, target, *more) if target.respond_to?(:stream_entry?) && target.stream_entry?
      return activity_account_status_url(target.account, target, *more) if target.reblog?
      account_status_url(target.account, target, *more)
    end
  end

  def with_replies_url_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    short_account_with_replies_url(target, *more)
  end

  def media_url_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    short_account_media_url(target, *more)
  end

  def embed_url_for(target, *more)
    raise ArgumentError, 'target must be a local activity' unless %i(note comment activity).include?(target.object_type) && target.local?

    embed_short_account_status_url(target.account, target, *more)
  end

  def stream_entry_url_for(target, *more)
    raise ArgumentError, 'target must be a local activity' unless %i(note comment activity).include?(target.object_type) && target.local?

    account_stream_entry_url(target.account, target, *more)
  end

  def followers_url_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_followers_url(target, *more)
  end

  def following_url_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_following_index_url(target, *more)
  end

  def mon_url_for(target, *more)
    raise ArgumentError, 'target must be a local Trainer' unless target.object_type == :trainer && target.local?

    trainer_mon_index_url(target, *more)
  end

  def follow_url_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_follow_url(target, *more)
  end

  def unfollow_url_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_unfollow_url(target, *more)
  end

  def remote_follow_url_for(target, *more)
    raise ArgumentError, 'target must be a local actor' unless %i(mon route trainer).include?(target.object_type) && target.local?

    account_remote_follow_url(target, *more)
  end
end
