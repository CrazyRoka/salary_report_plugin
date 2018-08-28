class SalaryReportsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @reports = SalaryReport.all.includes(:salary_report_entries).order(:payed_at)
  end

  def show
    @report = SalaryReport.find(params[:id])
    @entries = @report.salary_report_entries.includes(:issue)
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
      flash[:error] = 'There is nothing to report'
      return redirect_to salary_reports_url
    end
  end

  def create
    transaction = CreateReport.new.call(params)
    if transaction.success?
      flash[:success] = transaction.result
      redirect_to salary_reports_url
    else
      flash[:error] = transaction.failure
      redirect_to salary_reports_new_url
    end
  end
end
