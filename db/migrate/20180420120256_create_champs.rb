class CreateChamps < ActiveRecord::Migration[5.1]
  def up
    MajorComp.create(role: "spanish", name: "Campeonato de España")
    MajorComp.create(role: "euro", name: "Campeonato de Europa")
    MajorComp.create(role: "world", name: "Campeonato del Mundo")
  end

  def down
    MajorComp.delete_all
  end
end
