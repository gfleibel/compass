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
    record.mentor_id == user.id || record.mentee_id == user.id
  end

  def update?
    true
  end
end
