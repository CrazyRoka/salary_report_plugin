require_relative 'failure'
require_relative 'success'

class CreateReport
  def call(params)
    validate(params)
  end

  def validate(params)
    return Failure.new('Invalid params') unless params[:entries]
    entries = params.require(:entries)
    entries.each do |entry|
      return Failure.new('Invalid hours format') unless entry[:hours] =~ /^\d+\.?\d*$/
      return Failure.new('Invalid coefficient format') unless entry[:coefficient] =~ /^\d+\.?\d*$/
    end
    create(entries)
  end

  def create(entries)
    result = SalaryReport.transaction do
      report = SalaryReport.create!
      total_salary = 0
      entries.each do |entry|
        cur = SalaryReportEntry.create!(entry_params(entry, report))
        total_salary += cur.hours * cur.coefficient
      end
      @issues = Issue.all.includes(:salary_report_entries, :time_entries)
      @issues.each do |issue|
        elapsed_time = issue.time_entries.to_a.sum(&:hours)
        reported_time = issue.salary_report_entries.to_a.sum(&:hours)
        raise ArgumentError, 'Incorrect time' if elapsed_time - reported_time < 0
      end
      report.money_amount = total_salary
      report.save!
    end
    return Failure.new('Invalid data') unless result
    Success.new('Successfully created')
  rescue => e
    return Failure.new(e.message)
  end

  private

  def entry_params(entry, report)
    entry.merge({ salary_report_id: report.id })
         .permit(:issue_id, :hours, :salary_report_id, :coefficient)
  end
end
