module ChaptersHelper
  def editable_chapter_title(chapter)
    text_field_tag 'chapter[title]', chapter.title, 'data-chapter-id' => chapter.id, :class => :editable_chapter_heading, :id => nil, :placeholder => 'Chapter Title Required'
  end
  def editable_chapter_subtitle(chapter)
    text_field_tag 'chapter[subtitle]', chapter.subtitle, 'data-chapter-id' => chapter.id, :class => :editable_chapter_heading, :id => nil, :placeholder => 'Subtitle'
  end
end