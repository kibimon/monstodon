Fabricator('ActivityMon::Route', aliases: %i(route v2_route)) do
  last_webfingered_at { Time.now.utc }
end
