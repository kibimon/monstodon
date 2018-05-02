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
#  type                    :string           default("ActivityMon::Trainer")
#  mon_no                  :integer          not null
#  route_regional_no       :integer          not null
#  route_national_no       :integer          not null
#  trainer_no              :integer          not null
#  routing_version         :integer          default(2), not null
#

class ActivityMon::Route < Account
  validates :owner_id, :species_id, absence: true

  # Specific №s
  validates :route_regional_no, uniqueness: true, allow_nil: true
  validates :route_regional_no, presence: true, if: :changed?, unless: :new_or_remote?
  validates :route_national_no, uniqueness: true, allow_nil: true
  validates :route_national_no, presence: true, if: :changed?, unless: :new_record?
  validates :mon_id, absence: true
  validates :trainer_id, absence: true

  def regional?
    local?
  end

  def route?
    true
  end

  def username=(ignored)
    return super(ignored) unless local?
    nil
  end

  def username
    return super unless local?
    "Rt_#{route_regional_no.to_s.rjust(5, '0')}"
  end

  def object_type
    :route
  end

  def to_param
    route_regional_no.to_s.rjust(5, '0')
  end

  before_save :not_a_mon!
  before_save :not_a_trainer!
  before_save :is_a_route!

  private

  def is_a_route!
    if local?
      route_regional_no = nil if route_regional_no.nil?
    else
      route_regional_no = 0
    end
    route_national_no = nil if route_national_no.nil?
  end
end
