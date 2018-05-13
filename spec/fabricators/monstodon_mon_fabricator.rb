Fabricator('Monstodon::Mon', aliases: %i(mon v2_mon)) do
  routing_version 2
  last_webfingered_at { Time.now.utc }
  mon_no { sequence(:mon_no, 1) }
end
