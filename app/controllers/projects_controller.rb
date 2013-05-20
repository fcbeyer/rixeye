class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  
  include ProjectsHelper
  
  def find_revisions
  	project = Project.find(params[:id])
  	rev_from = project.last_revision.nil? ? project.base_revision : project.last_revision + 1
  	log_file = project.name + ".xml"
  	rev_to = "HEAD"
  	revision_results = []
  	problem = false
  	have_new_revision_data = true
  	
  	begin
  		response = system "svn log --verbose --username build --password build #{project.url_path} -r#{rev_from}:#{rev_to} --xml > #{log_file}"
  		doc = Nokogiri::XML(File.open(log_file))
  		if !doc.xpath('/log/logentry').empty?
		  	doc.xpath('/log/logentry').each do |entry|
		  		msg = parse_message(entry.xpath('./msg').text)
		  		cur_revision = Commit.new
		  		cur_revision.project_id = project.id
		  		cur_revision.issue = msg['issue']
		  		temp = entry.attribute('revision')
		  		cur_revision.revision_number = temp.to_s
		  		cur_revision.committed_at = Time.iso8601(entry.xpath('./date').text)
		  		cur_revision.author = entry.xpath('./author').text
		  		cur_revision.message = msg['complete']
		  		cur_revision.save
		  		entry.xpath('./paths/path').each do |path|
		  			cur_path = Path.new
		  			cur_path.commits_id = cur_revision.id
		  			temp = path.attribute('kind')
		  			cur_path.kind = temp.to_s
		  			temp = path.attribute('action')
		  			cur_path.action = temp.to_s
		  			cur_path.file = path.text
		  			cur_path.save
		  		end
		  	end
		  	
		  	#update project.last_revision to the last one we found just now
		  	temp = doc.xpath('/log/logentry').last.attribute('revision')
		  	project.last_revision = temp.to_s
		  else
		  	#nothing new was found
		  	have_new_revision_data = false
		  end
  	rescue
  		STDERR.puts "AHHH THIS IS AWFUL! #{$!}"
			problem = true
  	end
	  
	  project.last_run_time = Time.now
	  project.save
  	
  	revision_results.push(have_new_revision_data)
  	revision_results.push(project.display_name)
  	revision_results.push(problem)
  	
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
    
    @commits_by_day = @project.commits.order("committed_at desc").group_by { |commit| commit.committed_at.to_date}
    
    @commits_paginated = @project.commits.order("committed_at desc").page params[:page]

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
end
