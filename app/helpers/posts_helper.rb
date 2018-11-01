module PostsHelper
  def slug_classes(post)
    classes = ["slug"]
    unless post.new_record?
      classes << "manually-changed"
    end
    classes.join(" ")
  end

  def contextual_class(post)
    if post.draft
      "warning"
    elsif post.competition_page
      "dark"
    else
      "success"
    end
  end

  def legend(post)
    legends = []
    if post.competition_page
      legends << "Competición"
    end
    if post.feature
      legends << "Destacado"
    end
    if post.draft
      legends << "Borrador"
    else
      legends << "Público"
    end
    legends.join(" | ")
  end

  def post_tags_to_options
    Tag.distinct.pluck(:name).map { |tag| { value: tag, text: tag } }.to_json.html_safe
  end

  def view_post_path(post)
    if post.competition_page
      old_competitions_path(post.slug)
    else
      news_slug_path(post.slug)
    end
  end
end
