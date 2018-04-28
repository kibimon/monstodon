# frozen_string_literal: true

class ActivityMon::Adapter < ActivityPub::Adapter
  CONTEXT = {
    '@context': ActivityPub::Adapter::CONTEXT[:'@context'].concat([
      {
        "rp": "tag:marrus.xyz,2018:roleplaying::",
        "mon": "tag:marrus.xyz,2018:activitymon::",
      }
    ])
  }.freeze

  def context
    CONTEXT
  end
end