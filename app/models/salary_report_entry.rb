class SalaryReportEntry < ActiveRecord::Base
  belongs_to :issue,         required: true
  belongs_to :salary_report, required: true

  validates :hours, :coefficient, numericality: { greater_than: 0 }
end
