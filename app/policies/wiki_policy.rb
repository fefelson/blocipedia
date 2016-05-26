class WikiPolicy < ApplicationPolicy

  def create?
    return user.present? unless record.private?
    user.present? && (user.admin? || user.premium?)
  end

  def update?
    return false unless user.present?
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
      all_wikis = scope.all
      wikis = []
      if user.admin?
        wikis = all_wikis
      else
        all_wikis.each do |wiki|
          if wiki.public? || wiki.user == user || wiki.users.include?(user)
            wikis << wiki
          end
        end
      end
      wikis
    end
  end

end
