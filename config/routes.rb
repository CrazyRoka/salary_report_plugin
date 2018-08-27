# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'salary_reports', :to => 'salary_reports#index'
get 'salary_reports/new', :to => 'salary_reports#new'
post 'salary_reports', :to => 'salary_reports#create'
