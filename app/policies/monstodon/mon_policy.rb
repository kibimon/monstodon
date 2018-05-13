class Monstodon::MonPolicy < AccountPolicy
  def create?
    staff?
  end
end
