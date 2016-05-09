class WikiPolicy < ApplicationPolicy

  def create?
    unless record.private?
      user.present?
    else
      user.present? && (user.admin? || user.premium?)
    end
  end

  def edit?
    unless record.private?
      user.present?
    else
      user.present? && (user.admin? || user.premium?)
    end
  end

  def update?
    return false unless user.present?
    return true if user.admin? || user.premium?
    record.private? || record.params_private ? false : true
  end

  def destroy?
    user.present? && user.admin?  
  end



  class Scope < Scope
    def resolve
      return scope.where(private: false) unless user
      user.admin? || user.premium? ? scope.all : scope.where(private: false)
    end
  end

end
