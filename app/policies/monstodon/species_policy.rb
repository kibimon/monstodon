class Monstodon::SpeciesPolicy < ApplicationPolicy
  def index?
    staff?
  end

  def create?
    staff?
  end
end
