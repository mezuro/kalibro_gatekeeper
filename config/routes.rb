Rails.application.routes.draw do
  root 'information#data'

  #BaseTools
  get 'metric_collectors/all_names' => 'metric_collectors#all_names'
  post 'metric_collectors/get' => 'metric_collectors#get'

  #Configurations
  post 'configurations/exists' => 'configurations#exists'
  get 'configurations/all' => 'configurations#all'
  post 'configurations/save' => 'configurations#save'
  post 'configurations/get' => 'configurations#get'
  post 'configurations/destroy' => 'configurations#destroy'

  #MetricConfigurations
  post 'metric_configurations/save' => 'metric_configurations#save'
  post 'metric_configurations/get' => 'metric_configurations#get'
  post 'metric_configurations/destroy' => 'metric_configurations#destroy'
  post 'metric_configurations/of' => 'metric_configurations#of'

  #MetricResults
  post 'metric_results/history_of_metric' => 'metric_results#history_of_metric'
  post 'metric_results/descendant_results_of' => 'metric_results#descendant_results_of'
  post 'metric_results/of' => 'metric_results#of'

  #ModuleResults
  post 'module_results/get' => 'module_results#get'
  post 'module_results/children_of' => 'module_results#children_of'
  post 'module_results/history_of' => 'module_results#history_of'

  #Processings
  post 'processings/has' => 'processings#has'
  post 'processings/has_ready' => 'processings#has_ready'
  post 'processings/has_after' => 'processings#has_after'
  post 'processings/has_before' => 'processings#has_before'
  post 'processings/last_state_of' => 'processings#last_state_of'
  post 'processings/last_ready_of' => 'processings#last_ready_of'
  post 'processings/last_of' => 'processings#last_of'
  post 'processings/first_of' => 'processings#first_of'
  post 'processings/first_after_of' => 'processings#first_after_of'
  post 'processings/last_before_of' => 'processings#last_before_of'

  #Projects
  post 'projects/exists' => 'projects#exists'
  get 'projects/all' => 'projects#all'
  post 'projects/save' => 'projects#save'
  post 'projects/get' => 'projects#get'
  post 'projects/destroy' => 'projects#destroy'

  #Ranges
  post 'ranges/save' => 'ranges#save'
  post 'ranges/destroy' => 'ranges#destroy'
  post 'ranges/of' => 'ranges#of'

  #Readings
  post 'readings/save' => 'readings#save'
  post 'readings/get' => 'readings#get'
  post 'readings/destroy' => 'readings#destroy'
  post 'readings/of' => 'readings#of'

  #ReadingGroups
  post 'reading_groups/exists' => 'reading_groups#exists'
  get 'reading_groups/all' => 'reading_groups#all'
  post 'reading_groups/save' => 'reading_groups#save'
  post 'reading_groups/get' => 'reading_groups#get'
  post 'reading_groups/destroy' => 'reading_groups#destroy'

  #Repositories
  post 'repositories/save' => 'repositories#save'
  post 'repositories/destroy' => 'repositories#destroy'
  post 'repositories/of' => 'repositories#of'
  post 'repositories/process' => 'repositories#process_repository'
  post 'repositories/cancel_process' => 'repositories#cancel_process'
  get 'repositories/supported_types' => 'repositories#supported_types'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
