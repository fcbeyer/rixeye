class Whitelist < ActiveRecord::Base
  attr_accessible :project_id, :num_items, :branch_name, :items_attributes
  has_many :items, :dependent => :destroy
  belongs_to :project
end
