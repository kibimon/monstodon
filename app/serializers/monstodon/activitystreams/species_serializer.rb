# frozen_string_literal: true

class Monstodon::ActivityStreams::SpeciesSerializer < ActiveModel::Serializer
  include MonStrPub::ActivityStreams::SpeciesSerializerConcern
end
