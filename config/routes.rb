# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
get 'salary_reports', to: 'salary_reports#index'
get 'salary_reports/new', to: 'salary_reports#new'
get 'salary_reports/:id', to: 'salary_reports#show', as: :salary_report
post 'salary_reports', to: 'salary_reports#create'
patch 'salary_reports/:id', to: 'salary_reports#update'
