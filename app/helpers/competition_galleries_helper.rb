module CompetitionGalleriesHelper
  def cg_contextual_class(cg)
    if cg.draft
      "warning"
    else
      "success"
    end
  end

  def cg_legend(cg)
    legends = []
    if cg.feature
      legends << "Destacada"
    end
    if cg.draft
      legends << "Borrador"
    else
      legends << "Pública"
    end
    legends.join(" | ")
  end
end
