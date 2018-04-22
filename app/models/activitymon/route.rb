# == Schema Information
#
# Table name: accounts
#
#  id                      :integer          not null, primary key
#  username                :string           default(""), not null
#  domain                  :string
#  secret                  :string           default(""), not null
#  private_key             :text
#  public_key              :text             default(""), not null
#  remote_url              :string           default(""), not null
#  salmon_url              :string           default(""), not null
#  hub_url                 :string           default(""), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  note                    :text             default(""), not null
#  display_name            :string           default(""), not null
#  uri                     :string           default(""), not null
#  url                     :string
#  avatar_file_name        :string
#  avatar_content_type     :string
#  avatar_file_size        :integer
#  avatar_updated_at       :datetime
#  header_file_name        :string
#  header_content_type     :string
#  header_file_size        :integer
#  header_updated_at       :datetime
#  avatar_remote_url       :string
#  subscription_expires_at :datetime
#  silenced                :boolean          default(FALSE), not null
#  suspended               :boolean          default(FALSE), not null
#  locked                  :boolean          default(FALSE), not null
#  header_remote_url       :string           default(""), not null
#  statuses_count          :integer          default(0), not null
#  followers_count         :integer          default(0), not null
#  following_count         :integer          default(0), not null
#  last_webfingered_at     :datetime
#  inbox_url               :string           default(""), not null
#  outbox_url              :string           default(""), not null
#  shared_inbox_url        :string           default(""), not null
#  followers_url           :string           default(""), not null
#  protocol                :integer          default("ostatus"), not null
#  memorial                :boolean          default(FALSE), not null
#  moved_to_account_id     :integer
#  featured_collection_url :string
#  fields                  :jsonb
#  owner_id                :integer
#  species_id              :integer
#  mon_id                  :integer          not null
#  route_no                :integer          not null
#  trainer_id              :integer          not null
#

class ActivityMon::Route < Account
  validates :owner_id, :species_id, absence: true

  # Specific IDs
  validates :route_no, absence: true, on: :create
  validates :mon_id, numericality: { equal_to: 0 }
  validates :trainer_id, numericality: { equal_to: 0 }

  delegate :regional_dex, to: :species, prefix: false, allow_nil: true
  delegate :national_dex, to: :species, prefix: false, allow_nil: true

  before_validation :not_a_mon
  before_validation :not_a_trainer

  def username=(ignored)
    nil
  end

  def username
    "route_#{route_no}"
  end
end
