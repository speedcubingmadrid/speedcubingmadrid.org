class CreateChamps < ActiveRecord::Migration[5.1]
  def up
    MajorComp.create(role: "french", name: "Championnats de France")
    MajorComp.create(role: "euro", name: "Championnats d'Europe")
    MajorComp.create(role: "world", name: "Championnats du Monde")
  end

  def down
    MajorComp.delete_all
  end
end
