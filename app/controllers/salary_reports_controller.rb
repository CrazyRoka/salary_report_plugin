class SalaryReportsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @reports = SalaryReport.all.includes(:salary_report_entries).order(:payed_at)
  end

  def new
    @issues = Issue.includes(:project, :assigned_to, :time_entries, :salary_report_entries).order(:assigned_to_id, :project_id)
  end

  def create
    if create_report
      flash[:success] = "Successfully created"
    else
      flash[:error] = "Error creating report"
    end
    @reports = SalaryReport.all.includes(:salary_report_entries).order(:payed_at)
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
      report.save!
    end
  end

  def salary_report_params
    params.require(:entries)
  end

  def entry_params(entry, salary_report)
    p entry
    entry.merge({ salary_report_id: salary_report.id }).permit(:issue_id, :time_amount, :salary_report_id, :coefficient)
  end
end
