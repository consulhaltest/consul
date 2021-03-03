class Budgets::PhasesComponent < ApplicationComponent
  delegate :wysiwyg, :auto_link_already_sanitized_html, to: :helpers
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  private

    def phases
      budget.published_phases.to_a
    end

    def phase_name(phase)
      phase.name.presence || t("budgets.phase.#{phase.kind}")
    end

    def start_date(phase)
      l(phase.starts_at.to_date, format: :long) if phase.starts_at.present?
    end

    def end_date(phase)
      l(phase.ends_at.to_date - 1.day, format: :long) if phase.ends_at.present?
    end
end
