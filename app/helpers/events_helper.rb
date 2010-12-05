module EventsHelper

  def event_list_timestamp(event, previous_event)
    if previous_event && !event.details.is_a?(Chapter) && !previous_event.details.is_a?(Chapter) && event.happened_same_day_as(previous_event)
      if (event.timestamp - previous_event.timestamp) < 1.hour
        content_tag(:span, "...#{distance_of_time_in_words(previous_event.timestamp, event.timestamp)} later", :class => 'timestamp same_day')
      else
        content_tag(:span, event.timestamp.localtime.strftime('...then at %I:%M%p').gsub('at 0', 'at '), :class => 'timestamp same_day')
      end
    else
      event_timestamp(event)
    end
  end
  
  def event_timestamp(event)
    case event.details
    when Chapter, Note
    else
      content_tag(:span, event.timestamp.localtime.strftime('%B %e, %Y'), :class => :timestamp)
    end
  end
  
  def event_controls(event)
    case event.details
    when Chapter
      # do nothing
    else
      render :partial => '/events/event_controls', :locals => {:event => event}
    end
  end
  
  def event_service_icon(event)
    if event.authentication.present?
      service_name = event.authentication.service_name
      image_tag("services/#{service_name}.png", :title => service_name.titleize, :class => "service_icon")
    end
  end
  
  def event_new_chapter_link(event)
    link_to('Start a new chapter', split_chapter_path(:event_id => event.id), :remote => true, :class => 'new_chapter_link')
  end
  
  def event_class(event)
    case event.details
    when Chapter
      'chapter'
    else
      'event'
    end
  end
end