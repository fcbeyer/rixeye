class Commit < ActiveRecord::Base
  attr_accessible :author, :commmitted_at, :issue, :message, :revision, :project_id
  
  belongs_to :project
  
  scope :display, where(:active => true)
end
