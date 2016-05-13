class WikiPolicy < ApplicationPolicy

  def create?
    return user.present? unless record.private?
    user.present? && (user.admin? || user.premium?)
    end

  def update?
    if record.private?
      return false unless user.premium? || user.admin?
    end
    user.admin? || record.user == user
  end


  def destroy?
    user.present? && user.admin?
  end

  def show?
    return true unless record.private?
    user.present? && (user.admin? || user.premium?)
  end



  class Scope < Scope
    def resolve
      return scope.where(private: false) unless user
      user.admin? || user.premium? ? scope.all : scope.where(private: false)
    end
  end
1
end
