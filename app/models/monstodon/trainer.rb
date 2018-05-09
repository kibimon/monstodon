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
#  type                    :string           default("Monstodon::Trainer")
#  owner_id                :integer
#  species_id              :integer
#  mon_no                  :integer          not null
#  route_no                :integer          not null
#  trainer_no              :integer          not null
#  routing_version         :integer          default(2), not null
#  description             :string           default(""), not null
#

class Monstodon::Trainer < Account

  # Local users stuff
  delegate :email,
           :unconfirmed_email,
           :current_sign_in_ip,
           :current_sign_in_at,
           :confirmed?,
           :admin?,
           :moderator?,
           :staff?,
           :locale, to: :user, prefix: true, allow_nil: true

  delegate :filtered_languages, to: :user, prefix: false, allow_nil: true

  # MonStrPub stuff
  has_many :mon, class_name: 'Monstodon::Mon', inverse_of: :owner
  validates :owner_id, :species_id, absence: true

  # Specific №s
  validates :trainer_no, uniqueness: true, allow_nil: true
  validates :trainer_no, presence: true, if: :changed?, unless: :new_or_remote?
  validates :mon_no, absence: true
  validates :route_no, absence: true

  validates :username, presence: true

  # Remote user validations
  validates :username, uniqueness: { scope: :domain, case_sensitive: true }, if: -> { !local? && will_save_change_to_username? }

  # Local user validations
  validates :username, format: { with: /\A[a-z0-9_]+\z/i }, length: { maximum: 30 }, if: -> { local? && will_save_change_to_username? }
  validates :username, format: { without: /\Amon_|\ARt_.*N?\z/i }, if: -> { local? && will_save_change_to_username? }
  validates_with UniqueUsernameValidator, if: -> { local? && will_save_change_to_username? }
  validates_with UnreservedUsernameValidator, if: -> { local? && will_save_change_to_username? }
  validates :display_name, length: { maximum: 30 }, if: -> { local? && will_save_change_to_display_name? }
  validates :note, length: { maximum: 160 }, if: -> { local? && will_save_change_to_note? }

  def trainer?
    true
  end

  def object_type
    :trainer
  end

  def numero
    trainer_no.to_s.rjust(5, '0')
  end

  before_save :not_a_mon!
  before_save :not_a_route!
  before_save :is_a_trainer!

  private

  def is_a_trainer!
    if local?
      self.trainer_no = nil if trainer_no.nil?
    else
      self.trainer_no = 0
    end
  end
end
