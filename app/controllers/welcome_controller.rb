class WelcomeController < ApplicationController

  def welcome
    if logged_in?
      redirect_to(qfds_path)
    end
  end

end
