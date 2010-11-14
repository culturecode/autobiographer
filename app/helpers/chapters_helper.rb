module ChaptersHelper
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
  
  def chapter_header(chapter)
    content_tag :header do
      "".html_safe.tap do |output|
        output << content_tag(:h2, "Chapter #{chapter.number}: #{chapter.title}")
        output << content_tag(:h3, chapter.subtitle) if chapter.subtitle
      end
    end
  end
end