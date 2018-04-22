# frozen_string_literal: true

class TypedSpeciesValidator < ActiveModel::Validator
    def validate(species)
      types = 0
  
      # `nil` works here too, so this works for both `:create` and
      # `:update`
      types += 1 if species.regional_no != 0
      types += 1 if species.national_no != 0
      types += 1 if species.uri.present?
  
      species.errors[:base] << :multiple if types > 1
      species.errors[:base] << :none if types < 1
    end
  end
  