class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.text :title
      t.jsonb :details, null: false, default: '{}'
    end

  end
end
