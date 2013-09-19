module ApplicationHelper
	
	def active_flag_display(flag)
 		if flag.kind_of?(FalseClass)
 			#de-activated
 			tag(:i, :class => "icon-remove")
 		else
 			#active
 			tag(:i, :class => "icon-ok")
 		end
 	end
 	
 	def get_find_revisions_url(project)
 		find_revisions_project_path(project.id)
 	end
 	
 	def display_button(size, color)
 		if browser.ie?
 			return enabled_or_disabled_button(size,color,false)
 		else
 			return enabled_or_disabled_button(size,color,true)
 		end
 	end
 	
 	def enabled_or_disabled_button(size, color, enable)
 		if enable.kind_of?(FalseClass)
 			#disable the button
 			return raw("class=\"btn btn-#{size} btn-#{color}\" disabled")
 		else
 			#enable the button
 			return raw("class=\"btn btn-#{size} btn-#{color}\"")
 		end
 	end
 	
 	def create_settings_modal(key)
 		content_tag :div, :class => "control-group" do
 			label_tag('#{key}', parse_key(key)+":", :class => "control-label") +
 			content_tag(:div, :class => "controls") do
 				text_field_tag '#{key}',Rixeye::Application.config.rixeye_settings[key],disabled: true
 			end
 		end
 	end
 	
 	def parse_key(key)
 		output = key.gsub("_"," ")
 		return output
	end

	def sortable(column, title = nil)
		title ||= column.titleize
		direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
		arrow_val = (direction =="asc") ? "icon-arrow-up": "icon-arrow-down"
		link_to raw("#{title} <i class='#{arrow_val}'> </i>"), {:sort => column, :direction => direction}
	end

	def sort_column
		Item.column_names.include?(params[:sort]) ? params[:sort] : "reporter"
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
	end
 		
end
