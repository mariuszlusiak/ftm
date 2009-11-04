# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def show_page_info?
		if logged_in?
			current_user.show_page_info?
		else
			SHOW_PAGE_INFO
		end
	end

	def show_page_info(info)
		res = ''
		if show_page_info?
			res = "<div id='page-info'>#{info}</div>"
		end
		res
	end

end
