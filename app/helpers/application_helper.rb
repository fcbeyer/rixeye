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
 	
  def loading_bar
		content_tag(:div, :id => "loading_screen", :style => "display: none", :class => "progress progress-striped active") do
			content_tag(:div, :style => "width: 100%;", :class => "bar") do
				"Loading"
			end
		end
	end
	
end
