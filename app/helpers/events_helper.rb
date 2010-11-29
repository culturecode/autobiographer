module EventsHelper
  def event_spacer(event, previous_event = nil)
    content = "".html_safe.tap do |output|    
      case event.details
      when Chapter, Note
      else
        output << chapter_breaker(event) unless previous_event.details.is_a?(Chapter)
        output << annotation_inserter(event) unless previous_event.details.is_a?(Note)
      end
    end

    content_tag :li, content, :class => 'event_spacer', :id => "event_#{event.id}_spacer" if content.present?
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
end