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
end
