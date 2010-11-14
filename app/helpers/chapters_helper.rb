module ChaptersHelper
  def chapter_inserter
    content_tag :div, 'Insert Chapter', :class => 'chapter_inserter'
  end
end