# frozen_string_literal: true

module RPPub::ActivityStreams::InstanceSerializerConcern
  extend ActiveSupport::Concern

  included do
    attribute :rp_class, key: 'rp:class', if: :has_rp_class?
  end
end