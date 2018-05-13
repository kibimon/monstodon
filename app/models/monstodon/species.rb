# == Schema Information
#
# Table name: monstodon_species
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  uri         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  regional_no :integer          not null
#  national_no :integer          not null
#  summary     :string           default(""), not null
#  content     :string           default(""), not null
#

class Monstodon::Species < ApplicationRecord
  has_many :mon, class_name: "Monstodon::Mon", inverse_of: :species

  validates :regional_no, uniqueness: true, allow_nil: true
  validates :regional_no, absence: true, unless: :local?
  validates :national_no, uniqueness: true, allow_nil: true
  validates :national_no, presence: true, unless: :new_or_remote?
  validates :uri, absence: true, if: :native?

  def object_type
    :species
  end

  # The regional № can be nulled by the user (for now)
  def regional_no=(value)
    super 0 if value.nil?
    super value
  end

  def regional_no
    nillify_if_zero super
  end

  def national_no
    nillify_if_zero super
  end

  # Valid species types:
  #  Native species: no uri, have regional_no
  #  Imported species: no uri, no regional_no
  #  Remote species: uri, no regional_no
  #
  # Local species encompass Native + Imported
  # Foreign species encompass Imported + Remote
  def local?
    !uri.present?
  end

  def native?
    !regional_no.nil?
  end

  def imported?
    local? && !native?
  end

  def foreign?
    !local? || !native?
  end

  before_save :is_a_species!

  private

  def nillify_if_zero(val)
    return nil if val == 0
    val
  end

  def new_or_remote?
    new_record? || !local?
  end

  def not_native!
    self.regional_no = 0
  end

  def not_local!
    not_native!
    self.national_no = 0
  end

  def is_a_species!
    if local?
      self.regional_no = nil if regional_no.nil?
      self.national_no = nil if national_no.nil?
    else
      not_local!
    end
  end
end
