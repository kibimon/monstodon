# frozen_string_literal: true

module MonStrPub::ActivityStreams::MonSerializerConcern
  extend ActiveSupport::Concern

  include ActivityPub::ActivityStreams::ActorSerializerConcern
  include RPPub::ActivityStreams::InstanceSerializerConcern

  included do
    attribute :owner, key: :source, if: :has_owner?
  end

  def type
    ['Person', 'mon:Mon']
  end

  def owner
    ActivityPub::TagManager.instance.uri_for(object.owner)
  end

  def has_owner?
    object.owner.present?
  end

  def rp_class
    ActivityPub::TagManager.instance.uri_for(object.species)
  end

  def has_rp_class?
    object.species.present?
  end
end