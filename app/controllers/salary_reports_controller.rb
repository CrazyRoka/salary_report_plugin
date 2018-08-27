class SalaryReportsController < ApplicationController

  def index
  end

  def new
    @issues = Issue.includes(:project, :assigned_to, :time_entries).order(:project_id, :assigned_to_id)
    p @issues
  end

  def create
  end
end
