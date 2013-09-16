class WhitelistsController < ApplicationController
  # GET /whitelists
  # GET /whitelists.json
  
  before_filter :get_project
  
  def get_project
    @current_project = Project.find(params[:project_id])
  end
  
  def index
    @whitelists = Whitelist.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @whitelists }
    end
  end

  # GET /whitelists/1
  # GET /whitelists/1.json
  def show
    @whitelist = Whitelist.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @whitelist }
    end
  end

  # GET /whitelists/new
  # GET /whitelists/new.json
  def new
    @whitelist = Whitelist.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @whitelist }
    end
  end

  # GET /whitelists/1/edit
  def edit
    @whitelist = Whitelist.find(params[:id])
  end

  # POST /whitelists
  # POST /whitelists.json
  def create
    @whitelist = Whitelist.new(params[:whitelist])
    @whitelist.project_id = params[:project_id]

    respond_to do |format|
      if @whitelist.save
        format.html { redirect_to [@current_project,@whitelist], notice: 'Whitelist was successfully created.' }
        format.json { render json: @whitelist, status: :created, location: @whitelist }
      else
        format.html { render action: "new" }
        format.json { render json: @whitelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /whitelists/1
  # PUT /whitelists/1.json
  def update
    @whitelist = Whitelist.find(params[:id])

    respond_to do |format|
      if @whitelist.update_attributes(params[:whitelist])
        format.html { redirect_to [@current_project,@whitelist], notice: 'Whitelist was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @whitelist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /whitelists/1
  # DELETE /whitelists/1.json
  def destroy
    @whitelist = Whitelist.find(params[:id])
    @whitelist.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
