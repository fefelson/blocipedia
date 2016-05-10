class WelcomeController < ApplicationController
  skip_after_action :verify_policy_scoped
  def index
  end

  def about
  end
end
