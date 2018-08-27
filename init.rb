Redmine::Plugin.register :salary_report do
  name 'Person Coefficient plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  project_module :salary_report do
    permission :view_report, salary_reports: %i[index new create]
  end
  menu :application_menu, :salary_reports, { :controller => 'salary_reports', :action => 'index' }, :caption => 'Salary Report'
end
