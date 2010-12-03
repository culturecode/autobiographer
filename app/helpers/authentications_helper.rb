module AuthenticationsHelper
  def facebook_link
    service_link("facebook")
  end
  
  def twitter_link
    service_link("twitter")
  end
  
  def foursquare_link
    service_link("foursquare")
  end
  
  def service_link(name)
    if current_user.send("#{name}_authentication").blank?
      link_to image_tag("services/#{name}_grey.png"), send("new_#{name}_authentication_path"), :title => "Add your #{name.titleize} account"
    else
      link_to image_tag("services/#{name}.png"), send("#{name}_authentication_path", current_user.send("#{name}_authentication")), :method => :delete, :confirm => "This will delete all events from #{name.titleize}. Are you sure?", :title => "Remove your #{name.titleize} account"
    end
  end
end