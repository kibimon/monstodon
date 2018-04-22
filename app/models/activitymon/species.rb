# == Schema Information
#
# Table name: activitymon_species
#
#  id          :integer          not null, primary key
#  name        :string
#  uri         :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  regional_no :integer          not null
#  national_no :integer          not null
#

class ActivityMon::Species < ApplicationRecord
  validates_with TypedSpeciesValidator

  has_many :mon, class_name: "ActivityMon::Mon", inverse_of: :species

  validates :regional_no, uniqueness: true, if: :native?, unless: :new_record?
  validates :national_no, uniqueness: true, if: :local?, unless: :new_record?
  validates :uri, presence: true, unless: :native?
  validates :uri, absence: true, if: :native?

  def native?
    regional_no != 0
  end

  def local?
    national_no != 0
  end

  def imported?
    local? && !native?
  end

  def foreign?
    uri.present? && !native?
  end

  def not_native!
    self.regional_no = 0
  end

  def not_local!
    not_native!
    self.national_no = 0
  end

  def not_foreign!
    uri = nil
  end
end
