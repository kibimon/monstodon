# frozen_string_literal: true

module RoutingHelper
  extend ActiveSupport::Concern
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::AssetTagHelper
  include Webpacker::Helper

  included do
    def default_url_options
      ActionMailer::Base.default_url_options
    end
  end

  # Defines account_*_url methods as convenience so you don't have to
  # always switch on type
  %W[
    :
    stream_entry embed:stream_entry
    remote_follow
    with_replies media
    status activity:status embed:status
    followers following_index follow unfollow
    outbox inbox collection
  ].each do |suffix|
    if suffix.include? ':'
      prefix, suffix = suffix.split ':'
    else
      prefix = nil
    end
    name = "#{prefix}#{'_' unless prefix.nil?}account#{'_' unless suffix.nil?}#{suffix}_url"

    define_method name do |account, *more|
      case account.type
      when 'ActivityMon::Mon'
        root = 'mon'
      when 'ActivityMon::Route'
        root = 'route'
      when 'ActivityMon::Trainer'
        if account.routing_version == 1
          root = 'v1_trainer'
        else
          root = 'trainer'
        end
      end

      sym = "#{prefix}#{'_' unless prefix.nil?}#{root}#{'_' unless suffix.nil?}#{suffix}_url".to_sym

      send sym, account, *more
    end
  end

  # Defines short_account_*_url methods as convenience so you don't
  # have to always switch on type. These are only different for
  # Trainers.
  %w[
    : status with_replies media embed:status
  ].each do |suffix|
    if suffix.include? ':'
      prefix, suffix = suffix.split ':'
    else
      prefix = nil
    end
    name = "#{prefix}#{'_' unless prefix.nil?}short_account#{'_' unless suffix.nil?}#{suffix}_url"

    define_method name do |account, *more|
      case account.type
      when 'ActivityMon::Mon'
        root = 'mon'
      when 'ActivityMon::Route'
        root = 'route'
      when 'ActivityMon::Trainer'
        root = 'short_trainer'
      end

      sym = "#{prefix}#{'_' unless prefix.nil?}#{root}#{'_' unless suffix.nil?}#{suffix}_url".to_sym

      if account.type == 'ActivityMon::Trainer'
        send sym, { username: account.username }, *more
      else
        send sym, account, *more
      end
    end
  end

  def full_asset_url(source, **options)
    source = ActionController::Base.helpers.asset_url(source, options) unless use_storage?

    URI.join(root_url, source).to_s
  end

  def full_pack_url(source, **options)
    full_asset_url(asset_pack_path(source, options))
  end

  private

  def use_storage?
    Rails.configuration.x.use_s3 || Rails.configuration.x.use_swift
  end
end
