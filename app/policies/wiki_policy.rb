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
      #premium users should see wikis that are public, wikis they own and wikis they are collaborators on. 
      #regular users should see wikis that are public, wikis they own and wikis they are collaborators on.
      scope.where() #users (collaborators) include the currentu user. http://guides.rubyonrails.org/active_record_querying.html#scopes
    end
  end
end
