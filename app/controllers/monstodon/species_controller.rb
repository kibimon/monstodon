# frozen_string_literal: true

class Monstodon::SpeciesController < ApplicationController
  def show
    @species = Monstodon::Species.find_by_national_no!(params[:national_no])

    skip_session!
    render_cached_json(['monstodon', 'species', @species.cache_key], content_type: 'application/activity+json') do
      ActiveModelSerializers::SerializableResource.new(@species, serializer: Monstodon::ActivityStreams::SpeciesSerializer, adapter: MonStrPub::Adapter)
    end
  end
end
