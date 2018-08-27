class SalaryReportEntry < ActiveRecord::Base
  belongs_to :issue
  belongs_to :salary_report
end
