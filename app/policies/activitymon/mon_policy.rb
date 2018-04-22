class ActivityMon::MonPolicy < ApplicationPolicy
  def create?
    staff?
  end
end
