# frozen_string_literal: true

class Monstodon::ActivityStreams::SpeciesSerializer < ActiveModel::Serializer
  include RoutingHelper

  attributes :id, :name, :type

  attribute :uri, key: "source", unless: :native?

  def id
    species_url(object.national_no)
  end

  def type
    "mon:Species"
  end

  delegate :native?, to: :object
end
