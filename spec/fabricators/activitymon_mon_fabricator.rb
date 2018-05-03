Fabricator('ActivityMon::Mon', aliases: %i(mon v2_mon)) do
  last_webfingered_at { Time.now.utc }
end
