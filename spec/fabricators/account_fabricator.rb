Fabricator(:account, from: 'ActivityMon::Trainer', aliases: %i(v1_trainer)) do
  username { sequence(:username) { |i| "#{Faker::Internet.user_name(nil, %w(_))}#{i}" } }
  last_webfingered_at { Time.now.utc }
  routing_version 1
  trainer_no { sequence(:trainer_no, 1) }
end
