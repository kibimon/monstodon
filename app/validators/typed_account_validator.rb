# frozen_string_literal: true

class TypedAccountValidator < ActiveModel::Validator
  def validate(account)
    types = 0

    # `nil` works here too, so this works for both `:create` and
    # `:update`
    types += 1 if account.mon_id != 0
    types += 1 if account.route_no != 0
    types += 1 if account.trainer_id != 0

    account.errors[:base] << :multiple if types > 1
    account.errors[:base] << :none if types < 1
  end
end
