class Project < ActiveRecord::Base
  attr_accessible :active, :base_revision, :last_revision, :name, :url_path, :display_name
  
  has_many :commits, :dependent => :destroy	
  
  scope :active, where(:active => true)
end
