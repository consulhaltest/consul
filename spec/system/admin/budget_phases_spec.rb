require "rails_helper"

describe "Admin budget phases" do
  let(:budget) { create(:budget) }

  context "Edit", :admin do
    scenario "Update phase", :js do
      visit edit_admin_budget_budget_phase_path(budget, budget.current_phase)

      fill_in "start_date", with: Date.current + 1.day
      fill_in "end_date", with: Date.current + 12.days
      fill_in_ckeditor "Description", with: "New description of the phase."
      uncheck "budget_phase_enabled"
      click_button "Save changes"

      expect(page).to have_current_path(edit_admin_budget_path(budget))
      expect(page).to have_content "Changes saved"

      expect(budget.current_phase.starts_at.to_date).to eq((Date.current + 1.day).to_date)
      expect(budget.current_phase.ends_at.to_date).to eq((Date.current + 12.days).to_date)
      expect(budget.current_phase.description).to include("New description of the phase.")
      expect(budget.current_phase.enabled).to be(false)
    end

    scenario "Enable and disable a phase is possible from the budget view", :js do
      visit edit_admin_budget_path(budget)
      phase = budget.phases.enabled.sample

      expect(phase.enabled).to be true
      within "#budget_phase_#{phase.id}" do
        expect(find("#phase_enabled")).to be_checked
        uncheck "phase_enabled"
      end

      visit edit_admin_budget_path(budget)

      within "#budget_phase_#{phase.id}" do
        expect(find("#phase_enabled")).not_to be_checked
        expect(phase.reload.enabled).to be false
        check "phase_enabled"
      end

      visit edit_admin_budget_path(budget)

      within "#budget_phase_#{phase.id}" do
        expect(find("#phase_enabled")).to be_checked
      end
      expect(phase.reload.enabled).to be true
    end
  end
end
