class CreateSchoolsTable < ActiveRecord::Migration
  def change
    create_table :schools_tables do |t|
      t.text, :title
      t.jsonb :details, null: false, default: '{}'
    end

    add_index :schools, :details, using: :gin
  end
end
