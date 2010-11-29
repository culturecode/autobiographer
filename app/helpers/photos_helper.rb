module PhotosHelper
  def delete_photo_link(photo)
    link_to image_tag('blank.gif'), photo_path(photo), :method => :delete, :class => :delete_event_link, :remote => true
  end
end