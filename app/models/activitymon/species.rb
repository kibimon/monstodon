# == Schema Information
#
# Table name: activitymon_species
#
#  id         :integer          not null, primary key
#  name       :string
#  uri        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ActivityMon::Species < ApplicationRecord
    has_many :mon, class_name: "ActivityMon::Mon", inverse_of: :species
end
