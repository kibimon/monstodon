Fabricator('ActivityMon::Route', aliases: %i(route v2_route)) do
  routing_version 2
  last_webfingered_at { Time.now.utc }
  route_regional_no { sequence(:route_regional_no, 1) }
  route_national_no { sequence(:route_national_no, 1) }

end
