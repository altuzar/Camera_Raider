class HomeController < ApplicationController

  def index
  end

  def privacy
  end

  def ayuda
  end

  def get_out
  	sign_out
  	return redirect_to '/users/sign_in'
  end

  def test
    # raise request.env['HTTP_USER_AGENT']
    raise browser_detection
  end
end
