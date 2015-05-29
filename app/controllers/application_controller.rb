class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_user!

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  def admin_only
    if !current_user.has_role? :admin
      redirect_to '/', notice: "No autorizado / Not authorized"
      return
    end
  end

  def admin_or_operaciones_only
    if !current_user.has_role? :admin and !current_user.has_role? :operaciones
      redirect_to '/', notice: "No autorizado / Not authorized"
      return
    end
  end

  def admin_or_marketing_only
    if !current_user.has_role? :admin and !current_user.has_role? :marketing
      redirect_to '/', notice: "No autorizado / Not authorized"
      return
    end
  end

  def browser_detection
    # raise request.env['HTTP_USER_AGENT']
    result  = request.env['HTTP_USER_AGENT'].upcase
    browser_compatible = 'firefox'
    if result =~ /MSIE/
      browser_compatible = 'ie'
    elsif result =~ /IPHONE/ || result =~ /IPAD/
     browser_compatible = 'ios'
    end
    return browser_compatible
  end

  def get_feed
    feed_url = "http://#{@cameras[0].user}:#{@cameras[0].pass}@#{@cameras[0].ipaddress.gsub("http://","").gsub("/","")}/"
    feed_url = "#{feed_url}monitor.htm"  if @browser == 'ie'
    feed_url = "#{feed_url}monitor2.htm" if @browser == 'firefox'
    feed_url = "#{feed_url}pda.htm"      if @browser == 'ios'
    return feed_url
  end


end
