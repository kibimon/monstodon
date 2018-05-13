module MonStrPub::ActivityStreams::MonSerializerConcern
  extend ActiveSupport::Concern

  include ActivityPub::ActivityStreams::ActorSerializerConcern

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
end