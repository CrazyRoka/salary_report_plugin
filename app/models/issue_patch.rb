require_dependency 'issue'

class Issue < ActiveRecord::Base
  has_many :salary_report_entries
end
