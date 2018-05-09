class Monstodon::RoutePolicy < AccountPolicy
  def create?
    staff?
  end
end
