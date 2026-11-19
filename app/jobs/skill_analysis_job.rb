class SkillAnalysisJob < ApplicationJob
  queue_as :default

  # TODO: Replace stub with real AI analysis.
  #
  # Intended behavior:
  #   - Accept a Skill (or run across all skills on a schedule)
  #   - Send skill name, description, and trigger_keywords to Claude
  #   - Ask it to identify semantic conflicts with other skills
  #   - Write findings back to skill.ai_notes
  #   - Update skill.last_analyzed_at
  #
  # This job will be triggered on a cron schedule (e.g. nightly)
  # or enqueued after a skill is created/updated.

  def perform(skill)
    Rails.logger.info "[SkillAnalysisJob] Stub: would analyze skill ##{skill.id} (#{skill.name})"

    # Stubbed — no AI call yet
    skill.update!(
      last_analyzed_at: Time.current,
      ai_notes: "AI analysis not yet configured."
    )
  end
end
