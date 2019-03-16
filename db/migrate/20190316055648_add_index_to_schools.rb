class AddIndexToSchools < ActiveRecord::Migration[5.2]
  def change
    add_index :schools, :title, unique: true
    add_index :schools, :details, using: :gin
  end
end
