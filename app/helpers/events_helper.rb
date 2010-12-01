module EventsHelper
  def event_spacer(event, previous_event = nil)
    content = "".html_safe.tap do |output|    
      case event.details
      when Chapter, Note
      else
        output << chapter_breaker(event) unless previous_event.details.is_a?(Chapter) || event.happened_same_day_as(previous_event)
      end
    end

    content_tag :li, content, :class => 'event_spacer', :id => "event_#{event.id}_spacer" unless content.blank?
  end

  def chapter_breaker(event)
    link_to split_chapter_path(:event_id => event.id), :class => 'chapter_breaker', :remote => true do
      content_tag(:div, '', :class => :line) + content_tag(:span, 'Split Chapter', :class => :text)
    end
  end

  def annotation_inserter(event)
    link_to create_note_path(:event_id => event.id), :class => 'annotation_inserter', :remote => true do
      content_tag(:div, '', :class => :line) + content_tag(:span, 'Add Note', :class => :text)
    end
  end
  
  def delete_event_link(event_details)
    link_to image_tag('blank.gif'), polymorphic_path(event_details), :method => :delete, :class => :delete_event_link, :remote => true
  end
  
  def event_list_timestamp(event, previous_event)
    if event.happened_same_day_as(previous_event) && !previous_event.details.is_a?(Chapter)
      if (event.timestamp - previous_event.timestamp) < 3.hours
        content_tag(:span, "#{distance_of_time_in_words(previous_event.timestamp, event.timestamp)} later...", :class => 'timestamp later_that_day')
      elsif event.afternoon? && !previous_event.afternoon?
        content_tag(:span, "Later that afternoon...", :class => 'timestamp later_that_day')
      elsif event.evening? && !previous_event.evening?
        content_tag(:span, "That evening...", :class => 'timestamp later_that_day')
      end
    else
      event_timestamp(event)
    end
  end
  
  def event_timestamp(event)
    case event.details
    when Chapter, Note
    else
      content_tag(:span, event.timestamp.strftime('%B %d, %Y'), :class => :timestamp)
    end
  end
  
  def event_controls(event)
    case event.details
    when Chapter
      # do nothing
    else
      content_tag(:span, 'controls!!!', :class => :controls)
    end
  end
end