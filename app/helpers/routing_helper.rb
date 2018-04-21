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


  %w[
    url status_url stream_entry_url following_index_url
    activity:status_url
  ].each do |suffix|
    if suffix.include? ":"
      prefix, suffix = suffix.split ":"
      name = "#{prefix}_activitymon_trainer_#{suffix}".to_sym
      sym = "#{prefix}_account_#{suffix}".to_sym
    else
      name = "activitymon_trainer_#{suffix}".to_sym
      sym = "account_#{suffix}".to_sym
    end
    define_method name do |*args|
      send sym, *args
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
