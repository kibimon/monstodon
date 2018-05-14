# frozen_string_literal: true

module MonStrPub::ActivityStreams::SpeciesSerializerConcern
  extend ActiveSupport::Concern

  included do
    attributes :id, :name, :type

    attribute :uri, key: "source", unless: :native?
  end

  def id
    ActivityPub::TagManager.instance.species_url(object.national_no)
  end

  def type
    "mon:Species"
  end

  delegate :native?, to: :object
end
