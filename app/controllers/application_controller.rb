# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

	include AuthenticatedSystem

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
	
	def kick_not_admin
		unless current_user and current_user.is_admin?
			flash[:notice] = "Zaloguj się jako administrator aby obejrzeć stronę"
			redirect_back_or_default('/')
		end
	end

	# Put this after 'find_user' before_filter
	def kick_not_current_user_or_admin
		unless @user and current_user and (@user == current_user or current_user.is_admin?)
			flash[:notice] = "Nie masz dostępu do strony"
			redirect_back_or_default('/')
		end
	end

	def kick_logged_in
		if logged_in?
			flash[:notice] = 'Musisz być wylogowany aby wykonać tę akcję.'
			redirect_back_or_default('/')
		end
	end
	
end
