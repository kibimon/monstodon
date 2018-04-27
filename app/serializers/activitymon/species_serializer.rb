# frozen_string_literal: true

class ActivityMon::SpeciesSerializer < ActiveModel::Serializer
  include RoutingHelper

  attributes :id, :name

  attribute :uri, key: "source", unless: :native?

  def id
    species_url(object.national_no)
  end

  delegate :native?, to: :object
end