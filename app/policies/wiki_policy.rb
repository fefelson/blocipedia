class WikiPolicy < ApplicationPolicy

  def show?
    return record.public? if user.nil?
  end

end
