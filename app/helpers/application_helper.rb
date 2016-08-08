module ApplicationHelper
  def full_title(string = "")
    base_title = "Ruby On Rails Tutorial Sample App"
    if string.empty?
      base_title
    else
      "#{base_title} | #{string}"
    end
  end
end
