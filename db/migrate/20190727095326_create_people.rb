class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :wca_id
      t.string :name
      t.integer :s_333
      t.integer :a_333
      t.integer :s_222
      t.integer :a_222
      t.integer :s_444
      t.integer :a_444
      t.integer :s_555
      t.integer :a_555
      t.integer :s_666
      t.integer :a_666
      t.integer :s_777
      t.integer :a_777
      t.integer :s_333bf
      t.integer :a_333bf
      t.integer :s_333fm
      t.integer :a_333fm
      t.integer :s_333oh
      t.integer :a_333oh
      t.integer :s_333ft
      t.integer :a_333ft
      t.integer :s_clock
      t.integer :a_clock
      t.integer :s_minx
      t.integer :a_minx
      t.integer :s_pyram
      t.integer :a_pyram
      t.integer :s_skewb
      t.integer :a_skewb
      t.integer :s_sq1
      t.integer :a_sq1
      t.integer :s_444bf
      t.integer :a_444bf
      t.integer :s_555bf
      t.integer :a_555bf
      t.integer :s_333mbf

      t.integer :gold
      t.integer :silver
      t.integer :bronze
    end
  end
end
