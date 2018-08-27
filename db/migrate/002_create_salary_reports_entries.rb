class CreateSalaryReportsEntries < ActiveRecord::Migration
  def change
    create_table :salary_reports_entries do |t|
      t.belongs_to :salary_reports, null: false
      t.belongs_to :issues,         null: false
      t.decimal :time_amount,       default: 0
      t.decimal :coefficient,       default: 1
    end
  end
end
