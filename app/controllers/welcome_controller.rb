class WelcomeController < ApplicationController

  skip_after_action(:verify_authorized, :verify_policy_scoped)
  def index
    # pry.binding
  end

  def about
  end
end
