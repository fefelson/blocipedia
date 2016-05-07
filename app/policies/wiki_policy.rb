class WikiPolicy < ApplicationPolicy





  class Scope < Scope
    def resolve
      return scope.where(private: false) unless user
      user.admin? || user.premium? ? scope.all : scope.where(private: false)
    end
  end

end
