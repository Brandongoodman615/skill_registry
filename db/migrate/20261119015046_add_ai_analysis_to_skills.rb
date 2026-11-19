class AddAiAnalysisToSkills < ActiveRecord::Migration[8.1]
  def change
    add_column :skills, :last_analyzed_at, :datetime
    add_column :skills, :ai_notes, :text
  end
end
