class Project < ActiveRecord::Base
  attr_accessible :active, :base_revision, :last_revision, :name, :url_path, :display_name, :last_run_time, :auto_poll, :scm_type
  
  has_many :commits, :dependent => :destroy
  has_one :whitelist, :dependent => :destroy
  
  scope :active, where(:active => true)
  
  validate :verify_scm
  
  def verify_scm
  	self.scm_type.downcase!
  	if !self.scm_type.eql?("svn") and !self.scm_type.eql?("git")
  		errors.add(:scm_type," must be either SVN or Git")
  	end
  end
  
  def parse_xml(log_file,problem,have_new_revision_data)
  	begin
  		response = system "svn log --verbose --username #{Rixeye::Application.config.rixeye_settings['SVN_User']} --password #{Rixeye::Application.config.rixeye_settings['SVN_Password']} #{self.url_path} -r#{self.next_revision}:HEAD --xml > #{log_file}"
  		doc = Nokogiri::XML(File.open(log_file))
  		if !doc.xpath('/log/logentry').empty?
		  		Commit.parse_xml(doc.xpath('/log/logentry'),self)		  	
		  		#update project.last_revision to the last one we found just now
		  		temp = doc.xpath('/log/logentry').last.attribute('revision')
		  		self.last_revision = temp.to_s
		  else
		  	#nothing new was found
		  	have_new_revision_data = false
		  end
		rescue
  		STDERR.puts "AHHH THIS IS AWFUL! #{$!}"
			problem = true
  	end
  	return {:problem => problem,:have_new_revision_data => have_new_revision_data}
  end
  
  def next_revision
  	self.last_revision.nil? ? self.base_revision : self.last_revision + 1
  end
  
  def group_by_author
    self.commits.group("author").count
  end
  
  def group_by_issue
    issue_graph = self.commits.group("issue").count
    #need to delete the empty entry for all the commits that have NO issue number
    issue_graph.delete("")
    return issue_graph
  end
  
  def group_by_date(start_date)
    #find all commits for this project with a date greater than or equal to start_date
    arr_of_dates = self.commits.where(Commit.arel_table[:committed_at].gteq(start_date))
    #group the results by comitted_at date (drop the time)
    date_hash = arr_of_dates.group_by {|thing| thing.committed_at.to_date }
    date_hash.each_pair {|key,value| date_hash[key] = value.count }
    return date_hash
  end
  
  def group_by_day_of_week(start_date)
    #be awesome
  end
  
  def group_by_week(start_date)
    #be awesome
  end
  
  def group_by_month(start_date)
    #be awesome
  end
  
  def group_by_year(start_date)
    #be awesome
  end
  
end