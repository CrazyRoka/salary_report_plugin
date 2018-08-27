class CreateSalaryReports < ActiveRecord::Migration
  def change
    create_table :salary_reports do |t|
      t.datetime :payed_at, null: true
      t.decimal :money_amount, default: 0
    end
  end
end
