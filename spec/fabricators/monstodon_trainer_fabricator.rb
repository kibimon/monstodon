Fabricator('Monstodon::Trainer', aliases: %i(trainer v2_trainer)) do
  routing_version 2
  username { sequence(:username) { |i| "#{Faker::Internet.user_name(nil, %w(_))}#{i}" } }
  last_webfingered_at { Time.now.utc }
  trainer_no { sequence(:trainer_no, 1) }
end
