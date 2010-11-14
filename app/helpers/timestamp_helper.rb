module TimestampHelper
  def timestamp_with_conditional_year(datestamp)
    datestamp.strftime("%B #{datestamp.day}#{', \'%y' if Time.now.year != datestamp.year}")
  end

  def limited_time_ago_in_words(from_time, word_time_limit = 1.week, include_seconds = false)
    if (Time.now - from_time) > word_time_limit
      return from_time.strftime("%B %e, %Y")
    else
      time_ago_in_words(from_time, include_seconds) + " ago"
    end
  end
end
