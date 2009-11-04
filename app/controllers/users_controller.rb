class UsersController < ApplicationController

	before_filter :find_user, :except => ['new', 'create']
	before_filter :kick_logged_in, :only => ['new', 'create']
	before_filter :kick_not_current_user_or_admin, :except => ['new', 'create']

  def new
		respond_to do |format|
			format.html # new.html.erb
		end
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Dziękujemy za rejestrację!"
    else
      render :action => 'new'
    end
  end

	def show 
		respond_to do |format|
			format.html # show.html.erb
		end
	end

	def edit
		respond_to do |format|
			format.html # edit.html.erb
		end
	end

	def update
		respond_to do |format|
			if @user.update_attributes(params[:user])
				flash[:notice] = "Nowe ustawienia zostały zapisane"
				format.html { render :action => 'show' }
			else
				format.html { render :action => 'edit' }
			end
		end
	end

	private 

	def find_user
		@user = User.find(params[:id])
	end

end
