# frozen_string_literal: true

class MonStrPub::Adapter < ActivityPub::Adapter
  CONTEXT = {
    '@context': ActivityPub::Adapter::CONTEXT[:'@context'].concat([
      {
        'rp': 'https://www.monstr.pub/ns/roleplaying#',
        'mon': 'https://www.monstr.pub/ns/monstrpub#',
      }
    ])
  }.freeze

  def context
    CONTEXT
  end
end
