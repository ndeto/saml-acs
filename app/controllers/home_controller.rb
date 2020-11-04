class HomeController < ApplicationController
  before_action :verify_session, :only => [:index]
  def index
    # Nothing
  end

  private

  def verify_session
    unless session[:user_id]
      render :not_found
    end
  end
end
