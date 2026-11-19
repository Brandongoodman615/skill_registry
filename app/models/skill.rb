class Skill < ApplicationRecord
  STATUSES = %w[draft active deprecated].freeze

  validates :name, presence: true
  validates :status, inclusion: { in: STATUSES }

  # --- Keyword-based conflict detection (live) ---

  def keyword_list
    trigger_keywords.to_s.downcase.split(",").map(&:strip).reject(&:empty?)
  end

  def conflicts
    return [] if keyword_list.empty?

    Skill.where.not(id: id).select do |other|
      (keyword_list & other.keyword_list).any?
    end
  end

  def shared_keywords_with(other)
    keyword_list & other.keyword_list
  end

  def self.all_conflicts
    pairs = []
    all_skills = all.to_a
    all_skills.each_with_index do |skill, i|
      all_skills[(i + 1)..].each do |other|
        shared = skill.keyword_list & other.keyword_list
        pairs << { skill: skill, other: other, shared: shared } if shared.any?
      end
    end
    pairs
  end

  # --- AI semantic analysis (stubbed — scheduled job will populate these) ---
  # last_analyzed_at: timestamp of last AI analysis run
  # ai_notes: free-text findings from the AI job (semantic conflicts, suggestions)
end
