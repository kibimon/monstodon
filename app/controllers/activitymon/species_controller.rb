# frozen_string_literal: true

class ActivityMon::SpeciesController < ApplicationController
  def show
    @species = ActivityMon::Species.find_by_national_no!(params[:national_no])

    skip_session!
    render_cached_json(['activitymon', 'species', @species.cache_key], content_type: 'application/activity+json') do
      ActiveModelSerializers::SerializableResource.new(@species, serializer: ActivityMon::SpeciesSerializer, adapter: ActivityPub::Adapter)
    end
  end
end