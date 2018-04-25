module PostsHelper
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
      legends << "Compétition"
    end
    if post.feature
      legends << "Featured"
    end
    if post.draft
      legends << "Brouillon"
    else
      legends << "Public"
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
      news_path(post.slug)
    end
  end
end
