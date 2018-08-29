class SalaryReportsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @reports = SalaryReport.all.includes(:salary_report_entries)
                               .order(:payed_at, created_at: :desc)
  end

  def show
    @report = SalaryReport.find(params[:id])
    @entries = @report.salary_report_entries.includes(:issue)
  end

  def update
    @report = SalaryReport.find(params[:id])
    if @report.update(salary_report_params)
      redirect_to salary_reports_url, flash: { success: 'Updated payment' }
    else
      redirect_to salary_report(@report), flash: { error: 'Wrong date' }
    end
  end

  def new
    @issues = Issue.includes(:project, :assigned_to, :time_entries,
                             :salary_report_entries)
                   .order(:assigned_to_id, :project_id)
    @times = @issues.map do |issue|
      elapsed_time = issue.time_entries.to_a.sum(&:hours)
      reported_time = issue.salary_report_entries.to_a.sum(&:time_amount)
      elapsed_time - reported_time
    end
    if @times.count(0.0) == @times.size
      return redirect_to salary_reports_url, flash: { error: 'There is nothing to report' }
    end
  end

  def create
    transaction = CreateReport.new.call(params)
    if transaction.success?
      redirect_to salary_reports_url, flash: { success: transaction.result }
    else
      redirect_to salary_reports_new_url, flash: { error: transaction.failure }
    end
  end

  private

  def salary_report_params
    params.require(:salary_report).permit(:payed_at)
  end
end
