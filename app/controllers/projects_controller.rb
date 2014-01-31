class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  
  include ProjectsHelper
  
  def find_revisions
  	project = Project.find(params[:id])
  	log_file = project.name + ".xml"
  	revision_results = []
  	problem = false
  	have_new_revision_data = true
  	results_hash = project.parse_xml(log_file,problem,have_new_revision_data)
	  
	  project.last_run_time = Time.now
	  project.save
  	
  	revision_results.push(results_hash[:have_new_revision_data])
  	revision_results.push(project.display_name)
  	revision_results.push(results_hash[:problem])
  	
  	respond_to do |format|
			format.json {render json: revision_results}
			format.html {render html: revision_results}
  	end  	
  end #end find_revisions
  
  def index
    @projects = Project.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    @project = Project.find(params[:id])
    week = create_day_groups
    week.each_key {|key| week[key] = week[key].group_by {|commit| commit.committed_at.strftime('%H')}}
    @heat_graph,built_day = [],[]
    week.keys.each_with_index do |key,index|
    	week[key].each do |hour,commits_for_one_hour|
    		built_day.push([hour.to_i,index,commits_for_one_hour.count])
    	end
    	@heat_graph.push(built_day.dup)
    	built_day.clear
    end
    
    @author_graph = @project.group_by_author
    @issue_graph = @project.group_by_issue
    
    #@date_list = @project.group_by_date
    #@week_list = @project.group_by_week
    #@month_list = @project.group_by_month
    #@year_list = @project.group_by_year

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.json
  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
      	Whitelist.create_from_project(@project.id,@project.display_name)
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render json: @project, status: :created, location: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.json
  def update
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
  
private

	def create_day_groups
  	days = Array.new(7).map {|x| x = []}
  	@project.commits.each do |commit|
			days[commit.committed_at.wday].push(commit)
  	end
  	daysHash = {}
  	[:sunday,:monday,:tuesday,:wednesday,:thursday,:friday,:saturday].each_with_index {|day,key| daysHash[day] = days[key]}
  	return daysHash
  end  

end
