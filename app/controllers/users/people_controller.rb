class Users::PeopleController < ApplicationController
  # GET /people
  # GET /people.xml
	
	before_filter :find_user
	before_filter :kick_not_current_user_or_admin

  def index
    @people = @user.people
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /people/1
  # GET /people/1.xml
  def show
    @person = Person.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /people/new
  # GET /people/new.xml
  def new
    @person = Person.new
		@teams = { 'Brak' => nil }
		Team.all.each do |t|
			@teams[t.name] = t.id
		end
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
		@teams = { 'Brak' => nil }
		Team.all.each do |t|
			@teams[t.name] = t.id
		end
		respond_to do |format|
			format.html # edit.html.erb
		end
  end

  # POST /people
  # POST /people.xml
  def create
    @person = Person.new(params[:person])
		@person.user = @user
    respond_to do |format|
      if @person.save
        flash[:notice] = 'Nowa osoba została dodana.'
        format.html { redirect_to user_person_path(@user, @person) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.xml
  def update
    @person = Person.find(params[:id])
    respond_to do |format|
      if @person.update_attributes(params[:person])
        flash[:notice] = 'Dane osoby zostały uaktualnione.'
        format.html { redirect_to user_person_path(@user, @person)}
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.xml
  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    respond_to do |format|
      format.html { redirect_to(user_people_path(@user)) }
    end
  end

	private

	def find_user
		@user = User.find(params[:user_id])
	end

end
