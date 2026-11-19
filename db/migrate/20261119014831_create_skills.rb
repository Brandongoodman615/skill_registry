class CreateSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :skills do |t|
      t.string :name
      t.text :description
      t.string :trigger_keywords
      t.string :category
      t.string :file_path
      t.string :status

      t.timestamps
    end
  end
end
