class ActivityMon::SpeciesPolicy < ApplicationPolicy
  def index?
    staff?
  end

  def create?
    staff?
  end
end