class Project < ActiveRecord::Base
  attr_accessible :active, :base_revision, :last_revision, :name, :url_path, :display_name, :last_run_time, :auto_poll, :scm_type
  
  has_many :commits, :dependent => :destroy
  has_one :whitelist, :dependent => :destroy
  
  scope :active, where(:active => true)
  
  before_validation :verify_scm
  
  def verify_scm
  	self.scm_type.downcase!
  	if !self.scm_type.eql?("svn") and !self.scm_type.eql?("git")
  		errors[:base] << "SCM must be either SVN or Git!"
  		return false
  	end
  end
  
end
