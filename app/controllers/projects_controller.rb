class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.json
  
  include ProjectsHelper
  
  def find_revisions
  	project = Project.find(params[:id])
  	log_file = "log.xml"
  	rev_from = project.last_revision.nil? ? project.base_revision : project.last_revision + 1
  	rev_to = "HEAD"
  	revision_results = []
  	problem = false
  	have_new_revision_data = true
  	%x(svn log #{project.url_path} -r#{rev_from}:#{rev_to} --xml > #{log_file})
  	
  	begin
  		doc = Nokogiri::XML(File.open(log_file))
  	rescue
  		STDERR.puts "AHHH THIS IS AWFUL! #{$!}"
			problem = true
  	end
  	if !doc.css('log logentry').empty?
	  	doc.css('log logentry').each do |entry|
	  		msg = parse_message(entry.css('msg').text)
	  		cur_revision = Commit.new
	  		cur_revision.project_id = project.id
	  		cur_revision.issue = msg['issue']
	  		temp = entry.attribute('revision')
	  		cur_revision.revision_number = temp.to_s
	  		cur_revision.committed_at = Time.iso8601(entry.css('date').text)
	  		cur_revision.author = entry.css('author').text
	  		cur_revision.message = msg['complete']
	  		cur_revision.save
	  	end
	  	
	  	#update project.last_revision to the last one we found just now
	  	temp = doc.css('log logentry').last.attribute('revision')
	  	project.last_revision = temp.to_s
	  	project.save
	  else
	  	#nothing new was found
	  	have_new_revision_data = false
	  end
  	
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
    @commits = @project.commits.order("committed_at desc")

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
