# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details


#  def render(*args)
#  	args.first[:layout] = false if request.xhr? and args.first and args.first[:layout].nil?
#	super
#  end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
