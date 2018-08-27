class CreateSalaryReports < ActiveRecord::Migration
  def change
    create_table :salary_reports do |t|
      t.datetime :payed_at
      t.decimal :money_amount
    end
  end
end
