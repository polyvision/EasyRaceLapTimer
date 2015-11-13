class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_websocket_host
  
  def set_websocket_host
    if ENV['RAILS_CABLE_IP'].blank?
      @RAILS_CABLE_IP = "127.0.0.1"
    else
      @RAILS_CABLE_IP = ENV['RAILS_CABLE_IP']
    end
  end
end
