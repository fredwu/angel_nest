module ApplicationHelper
  def time_ago(time)
    t 'meta.time_ago', :time => time_ago_in_words(time)
  end
end
