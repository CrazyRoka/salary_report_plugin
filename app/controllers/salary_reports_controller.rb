class SalaryReportsController < ApplicationController

  def index
  end

  def new
    @issues = Issue.includes(:project, :assigned_to, :time_entries, :salary_report_entries).order(:assigned_to_id, :project_id)
    p @issues
  end

  def create
    if create_report
      flash[:success] = "Successfully created"
    else
      flash[:error] = "Error creating report"
    end
    render 'index'
  end

  private

  def create_report
    SalaryReport.transaction do
      report = SalaryReport.create!
      total_salary = 0
      salary_report_params.each do |entry|
        cur = SalaryReportEntry.create!(entry_params(entry, report))
        total_salary += cur.time_amount * cur.coefficient
      end
      report.money_amount = total_salary
    end
  end

  def salary_report_params
    params.require(:entries)
  end

  def entry_params(entry, salary_report)
    entry.merge({ salary_report_id: salary_report.id }).permit(:issue_id, :time_amount, :salary_report_id, :coefficient)
  end
end
