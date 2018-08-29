class SalaryReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_report, only: %i[show delete proceed_payment]

  def index
    @reports = SalaryReport.all.includes(:salary_report_entries)
                               .order(:payed_at, created_at: :desc)
  end

  def show
    @entries = @report.salary_report_entries.includes(:issue)
  end

  def new
    @issues = Issue.includes(:project, :assigned_to, :time_entries,
                             :salary_report_entries)
                   .order(:assigned_to_id, :project_id)
    @times = @issues.map do |issue|
      elapsed_time = issue.time_entries.to_a.sum(&:hours)
      reported_time = issue.salary_report_entries.to_a.sum(&:hours)
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

  def delete
    @report.destroy
    redirect_to salary_reports_url, flash: { success: 'Deleted successfully' }
  end

  def proceed_payment
    if @report.payed_at
      redirect_to salary_report_url(@report), flash: { error: 'Already payed' }
    else
      @report.update!(payed_at: Time.now)
      redirect_to salary_report_url(@report), flash: { success: 'Payed successfully' }
    end
  end

  private

  def set_report
    @report = SalaryReport.find(params[:id])
  end
end
