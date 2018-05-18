# frozen_string_literal: true

class ActivityPub::ActorSerializer < ActiveModel::Serializer
  include ActivityPub::ActivityStreams::ActorSerializerConcern
  include MonStrPub::ActivityStreams::TrainerSerializerConcern

  class CustomEmojiSerializer < ActivityPub::EmojiSerializer
  end

  class Account::FieldSerializer < ActiveModel::Serializer
    attributes :type, :name, :value

    def type
      'PropertyValue'
    end

    def value
      Formatter.instance.format_field(object.account, object.value)
    end
  end
end
