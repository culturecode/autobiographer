module ChaptersHelper  
  def chapter_header(chapter)
    content_tag :header do
      "".html_safe.tap do |output|
        output << content_tag(:h2, "Chapter #{chapter.number}: #{chapter.title}")
        output << content_tag(:h3, chapter.subtitle) if chapter.subtitle
      end
    end
  end
end