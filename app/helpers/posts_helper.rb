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
end
