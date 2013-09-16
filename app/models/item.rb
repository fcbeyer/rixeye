class Item < ActiveRecord::Base
  attr_accessible :comment, :issue, :whitelist_id
end
