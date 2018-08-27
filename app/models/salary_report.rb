class SalaryReport < ActiveRecord::Base
  has_many :salary_report_entries, dependent: :destroy
end
