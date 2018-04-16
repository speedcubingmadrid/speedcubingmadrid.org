module CompetitionsHelper
  def class_and_status_from_person(sub_by_id, sub_by_name, person)
    if @subscribers_by_id.include?(person["wcaId"]) ||
       @subscribers_by_name.include?(person["name"].downcase)
      ["success", "Pris en charge par l'AFS"]
    elsif person["wcaId"]
      ["danger", "Doit payer"]
    else
      ["warning", link_to("Vérifier s'il est nouveau compétiteur", "#", class: "link-check", data: { id: person["registration"]["wcaRegistrationId"] })]
    end
  end
end
