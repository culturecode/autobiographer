module EventsHelper
  def event_spacer(event, previous_event = nil)
      if event.details.is_a?(Chapter)
        chapter = event.details
        output = chapter_joiner(chapter) unless chapter.first?
      elsif !previous_event.details.is_a?(Chapter)
        output = chapter_breaker(event)
      end
      content_tag :li, output, :class => 'event_spacer' if output
  end
  
  def chapter_joiner(chapter)
    link_to chapter_path(chapter), :method => :delete, :class => 'chapter_joiner', :remote => true do
      content_tag :span, 'Join Chapters'
    end
  end

  def chapter_breaker(event)
    link_to split_chapter_path(:timestamp => event.timestamp), :class => 'chapter_breaker', :remote => true do
      content_tag(:span, 'Split Chapter')
    end
  end
end