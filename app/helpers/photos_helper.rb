module PhotosHelper
  def delete_photo_link(photo)
    link_to image_tag('blank.gif'), photo_path(photo), :method => :delete, :confirm => 'Are you sure?', :class => :delete_photo_link, :remote => true
  end
end