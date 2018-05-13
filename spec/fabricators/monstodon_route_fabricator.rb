Fabricator('Monstodon::Route', aliases: %i(route v2_route)) do
  routing_version 2
  last_webfingered_at { Time.now.utc }
  route_no { sequence(:route_no, 1) }
end
