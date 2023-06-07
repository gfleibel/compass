class MatchPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    record.first.user == user
  end

  def create?
    true
  end

  def destroy?
    record.match == user.match
  end

  def update?
    true
  end
end
