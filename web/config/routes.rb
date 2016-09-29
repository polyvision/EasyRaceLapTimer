#require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users
  #mount Sidekiq::Web => '/sidekiq'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  mount ActionCable.server => '/cable'

  get 'visor' => 'visor#index'
  get 'race_director' => 'race_director#index'
  get 'race_director/lap_times' => 'race_director#lap_times'
  get 'race_director/invalidate_lap' => 'race_director#invalidate_lap'
  get 'race_director/undo_invalidate_lap' => 'race_director#undo_invalidate_lap'
  get 'race_director/start_next_race_event_race' => 'race_director/start_next_race_event_race'
  get 'race_director/stop_race_event_race' => 'race_director/stop_race_event_race'
  get 'race_director/start_next_race_event_heat' => 'race_director/start_next_race_event_heat'
  get 'race_director/preview_next_fpv_sports_race' => 'race_director#preview_next_fpv_sports_race'
  get 'race_director/start_next_fpv_sports_race' => 'race_director#start_next_fpv_sports_race'


  get 'system' => 'system#index'
  get '/system/pilot' => 'system/pilot#index'
  post '/system/pilot/create' => 'system/pilot#create'
  get '/system/pilot/edit/:id' => 'system/pilot#edit'
  patch '/system/pilot/update/:id' => 'system/pilot#update'
  delete '/system/pilot/delete/:id' => 'system/pilot#delete'
  get '/system/pilot/prepare_import' => 'system/pilot#prepare_import'
  post '/system/pilot/import' => 'system/pilot#import'
  get '/system/pilot/deactivate_token/:id' => 'system/pilot#deactivate_token'
  post '/system/set_config_val/:id' => 'system#set_config_val'
  get '/system/shutdown' => 'system#shutdown'

  get '/system/race_event' => 'system/race_event#index'
  get 'system/race_event/manage/:id' => 'system/race_event#manage'
  get '/system/race_event/new' => 'system/race_event#new'
  post '/system/race_event/create' => 'system/race_event#create'
  delete '/system/race_event/delete/:id' => 'system/race_event#destroy'
  get '/system/race_event/invalidate_heat_for_group/:id' => 'system/race_event#invalidate_heat_for_group'
  get 'system/race_event/edit_group/:id' => 'system/race_event#edit_group'
  delete 'system/race_event/del_pilot_from_group/:id' => 'system/race_event#del_pilot_from_group'
  post 'system/race_event/add_pilot_to_group/:id' => 'system/race_event#add_pilot_to_group'
  post 'system/race_event/update_pilot_token/:id' => 'system/race_event#update_pilot_token'

  get 'system/racebox' => 'system/race_box#index'
  get 'system/racebox/get_current_rssi' => 'system/race_box#get_current_rssi'
  get 'system/racebox/get_saved_rssi' => 'system/race_box#get_saved_rssi'
  post 'system/racebox/set_saved_rssi/:vtx_id' => 'system/race_box#set_saved_rssi'

  get '/system/user' => 'system/user#index'
  get '/system/user/new' => 'system/user#new'
  post '/system/user/create' => 'system/user#create'
  get '/system/user/:id' => 'system/user#edit'
  delete '/system/user/delete/:id' => 'system/user#destroy'
  put '/system/update/:id' => 'system/user#update'

  get 'system/soundfile' => 'system/soundfile#index'
  patch 'system/soundfile/:id' => 'system/soundfile#update'
  get 'system/soundfile/clear/:id' => 'system/soundfile#clear'

  post 'system/soundfile/create_custom' => 'system/soundfile#create_custom'
  delete 'system/soundfile/delete_custom/:id' => 'system/soundfile#delete_custom'

  get 'system/soundfile/change_volume' => 'system/soundfile#change_volume'

  get '/system/stop_race_session' => 'system#stop_race_session'
  post '/system/start_race_session' => 'system#start_race_session'

  patch 'system/update_style' => 'system#update_style'

  get '/monitor' => 'monitor#index'
  get '/monitor/view' => 'monitor#view'

  get '/pilots' => 'pilots#index'
  get '/pilots/:id/laps' => 'pilots#laps'

  get '/history' =>  'history#index'
  get '/history/show/:id' =>  'history#show'
  get '/history/:race_session_id/invalidate_lap/:id' =>  'history#invalidate_lap'
  get '/history/:race_session_id/validate_lap/:id' =>  'history#validate_lap'
  get '/history/:race_session_id/merge_up/:id' =>  'history#merge_up'
  get '/history/:race_session_id/merge_down/:id' =>  'history#merge_down'
  get '/history/:race_session_id/unmerge/:id' =>  'history#unmerge'
  get '/history/:race_session_id/synchronize_fpv_sports' =>  'history#synchronize_fpv_sports'
  get '/history/pdf_body/:id' =>  'history#pdf_body'
  get '/history/pdf/:id.:format' => 'history#pdf'
  delete '/history/delete/:id' =>  'history#delete'

  ########### API
  get 'api/v1/pilot' => 'api/v1/pilot#index'

  post 'api/v1/lap_track' => 'api/v1/lap_track#create'
  post 'api/v1/satellite' => 'api/v1/satellite#create'
  get 'api/v1/satellite' => 'api/v1/satellite#create'
  get 'api/v1/lap_track/create' => 'api/v1/lap_track#create'
  delete 'api/v1/lap_track/:lap_id/:ra_id' => 'api/v1/lap_track#destroy'
  get 'api/v1/monitor' => 'api/v1/monitor#index'
  get 'api/v1/sound/play_custom/:id' => 'api/v1/sound#play_custom'

  get 'api/v1/race_session/new' => 'api/v1/race_session#new'
  post 'api/v1/race_session/new_competition' => 'api/v1/race_session#new_competition'
  get 'api/v1/race_session/update_race_session_idle_time' => 'api/v1/race_session#update_race_session_idle_time'

  get 'api/v1/info/last_scanned_token' => 'api/v1/info#last_scanned_token'

  post 'api/v1/race_event/next_heat' => 'api/v1/race_event#next_heat'
  post 'api/v1/race_event/start_next_race' => 'api/v1/race_event#start_next_race'

  post 'api/v1/race_box/update_receiver' => 'api/v1/race_box#update_receiver'
  get 'api/v1/race_box/update_receiver' => 'api/v1/race_box#update_receiver'


  root 'monitor#index'

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
