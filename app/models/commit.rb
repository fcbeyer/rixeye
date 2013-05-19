class Commit < ActiveRecord::Base
  attr_accessible :author, :commmitted_at, :issue, :message, :revision, :project_id
  
  has_many :paths, :dependent => :destroy	
  
  belongs_to :project
  
  paginates_per 35
end
