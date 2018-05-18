# frozen_string_literal: true

module MonStrPub::ActivityStreams::TrainerSerializerConcern
  extend ActiveSupport::Concern

  included do
    attribute :mon, key: 'mon:mon'
  end

  def mon
    ActivityPub::TagManager.instance.mon_uri_for(object)
  end
end
