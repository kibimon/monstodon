class ActivityMon::SpeciesPolicy < ApplicationPolicy
  def index?
    staff?
  end
end