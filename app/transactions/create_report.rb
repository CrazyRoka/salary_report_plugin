require_relative 'failure'
require_relative 'success'

class CreateReport
  def call(params)
    validate(params)
  end

  def validate(params)
    return Failure.new('Invalid params') unless params[:entries]
    create(params.require(:entries))
  end

  def create(entries)
    result = SalaryReport.transaction do
      report = SalaryReport.create!
      total_salary = 0
      entries.each do |entry|
        cur = SalaryReportEntry.create!(entry_params(entry, report))
        total_salary += cur.time_amount * cur.coefficient
      end
      report.money_amount = total_salary
      report.save!
    end
    return Failure.new('Invalid data') unless result
    Success.new('Successfully created')
  end

  private

  def entry_params(entry, report)
    entry.merge({ salary_report_id: report.id })
         .permit(:issue_id, :time_amount, :salary_report_id, :coefficient)
  end
end
