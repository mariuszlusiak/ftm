class FieldsController < ApplicationController

  before_filter :login_required
  before_filter :find_field, :only => [:show, :edit, :update, :destroy]

  def index
    @fields = current_user.fields
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

  private

    def find_field
      @field = Field.find params[:id]
      check_access_rights_to_resource @field
    end

end
