module ApplicationHelper
  include AuthenticatedSystem::HelperMethods
  
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
      image_tag("services/#{name}.png", :title => "Your #{name.titleize} account is linked")
    end
  end
end
