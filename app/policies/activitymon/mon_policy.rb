class ActivityMon::MonPolicy < AccountPolicy
  def create?
    staff?
  end
end
