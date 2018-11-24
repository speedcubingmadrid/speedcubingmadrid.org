module CompetitionsHelper
  def class_and_status_from_person(sub_by_id, sub_by_name, person)
    if @subscribers_by_id.include?(person["wcaId"]) ||
       @subscribers_by_name.include?(person["name"].downcase)
      ["success", "Socio de la AMS"]
    elsif person["wcaId"]
      ["danger", "Sin descuento"]
    else
      ["warning", link_to("Comprueba si es un nuevo competidor", "#", class: "link-check", data: { id: person["registration"]["wcaRegistrationId"] })]
    end
  end
end
