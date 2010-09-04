class FieldsController < ApplicationController

  before_filter :login_required
  before_filter :find_field, :only => [:show, :edit, :update, :destroy,
    :toggle_in_tournament]
  before_filter :find_tournament, :only => [:index, :manage_in_tournament,
    :toggle_in_tournament]

  def index
    if @tournament
      @fields = @tournament.fields
    else
      @fields = current_user.fields
    end
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def new
    @field = Field.new
    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def create
    @field = Field.new params[:field]
    @field.user = current_user
    respond_to do |format|
      if @field.save
        flash[:notice] = 'Boisko zostało utworzone'
        format.html { redirect_to(@field) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    respond_to do |format|
      if @field.update_attributes params[:field]
        flash[:notice] = 'Informacje o boisku zostały uaktualnione.'
        format.html { redirect_to(@field) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @field.destroy
    respond_to do |format|
      format.html { redirect_to(fields_url) }
    end
  end
  
  def manage_in_tournament
    @fields = current_user.fields
     respond_to do |format|
       format.html
     end
  end
  
  def toggle_in_tournament
	  if @tournament.fields.include? @field
	    @tournament.fields.delete @field
	  else
	    @tournament.fields << @field  
	  end
	  @tournament.save
	  respond_to do |format|
	    format.js do
	      render :update do |page|
	        page.replace_html "field-in-tournament-#{@field.id}",
	          render(:partial => "field_in_tournament", :object => @field,
              :locals => { :tournament => @tournament })
	      end
	    end
	  end
  end

  private

    def find_field
      @field = Field.find params[:id]
      check_access_rights_to_resource @field
    end
    
    def find_tournament
	    if params[:tournament_id]
  	    @tournament = Tournament.find params[:tournament_id] 
  	    check_access_rights_to_resource @tournament
  	  end
	  end

end
