Rails.application.routes.draw do
  get 'home/top'
  get 'home/empty'
  post 'home/scrape'
  post 'home/all_destroy'
  post 'home/job_destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
