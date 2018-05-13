module ActivityPub::ActivityStreams::ActorSerializerConcern
  extend ActiveSupport::Concern

  class EndpointsSerializer < ActiveModel::Serializer
    include RoutingHelper

    attributes :shared_inbox

    def shared_inbox
      inbox_url
    end
  end

  included do
    attributes :id, :type, :following, :followers,
               :inbox, :outbox, :featured,
               :name, :summary,
               :url, :manually_approves_followers

    has_one :endpoints, serializer: EndpointsSerializer

    has_one :public_key, serializer: ActivityPub::PublicKeySerializer

    has_many :virtual_tags, key: :tag
    has_many :virtual_attachments, key: :attachment

    has_one :icon,  serializer: ActivityPub::ImageSerializer, if: :avatar_exists?
    has_one :image, serializer: ActivityPub::ImageSerializer, if: :header_exists?

    attribute :moved_to, if: :moved?
    delegate :moved?, to: :object
  end

  def id
    ActivityPub::TagManager.instance.uri_for(object)
  end

  def type
    'Person'
  end

  def following
    ActivityPub::TagManager.instance.following_uri_for(object)
  end

  def followers
    ActivityPub::TagManager.instance.followers_uri_for(object)
  end

  def inbox
    ActivityPub::TagManager.instance.inbox_uri_for(object)
  end

  def outbox
    ActivityPub::TagManager.instance.outbox_uri_for(object)
  end

  def featured
    ActivityPub::TagManager.instance.collection_uri_for(object, :featured)
  end

  def endpoints
    object
  end

  def preferred_username
    object.username
  end

  def name
    object.display_name
  end

  def summary
    Formatter.instance.simplified_format(object)
  end

  def public_key
    object
  end

  def icon
    object.avatar
  end

  def image
    object.header
  end

  def avatar_exists?
    object.avatar.exists?
  end

  def header_exists?
    object.header.exists?
  end

  def url
    TagManager.instance.url_for(object)
  end

  def manually_approves_followers
    object.locked
  end

  def virtual_tags
    object.emojis
  end

  def virtual_attachments
    object.fields
  end

  def moved_to
    ActivityPub::TagManager.instance.uri_for(object.moved_to_account)
  end
end