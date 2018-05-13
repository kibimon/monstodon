# frozen_string_literal: true

class Monstodon::ActivityStreams::MonSerializer < ActiveModel::Serializer
  include MonStrPub::ActivityStreams::MonSerializerConcern
end