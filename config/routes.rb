Rails.application.routes.draw do

  # match ':controller(/:action(/:id(.:format)))', :via => :all

  namespace :cct_vast_db do
    resources :cameras do
      collection do

        put  :create
        patch :update
        patch :update_soc

        post :import
        get  :create_database_index
        get  :show_cam_info
        get  :show_cam_info_index
        get  :show_soc_info
        get  :show_soc_info_index


        get  :new_and_update_cam_info_index
        get  :new_cam_info_index
        post  :new_cam_info_index

        patch :new_cam_info


        post :update_cam_info_index
        get  :update_cam_info_index
        patch  :update_success
        get  :update_cam_info

        post :test_update
        patch :test_update

        get  :update_cam_other_info_index
        get  :update_cam_other_info

        # post :create_other_info
        post :create_camera_other_info

        get  :export_csv_index

        # post  :update_cam_info_index
        # post  :update_cam_info
        # patch :update_cam_info
      end
    end
  end

  namespace :cct_vast_db do
    resources :camera_other_infos do
      collection do
        post :import
        get  :import_success
        get  :import_fail
      end
    end
  end

  namespace :cct_vast_db do
    resources :test_soc_cameras do
      collection do
        post :import
        get  :import_success
      end
    end
  end

  namespace :cct_vast_db do
    resources :show_cam_info_and_updates do
      collection do
        post  :import
        get   :import_success
      end
    end
  end

  # root to: "cct_vast_db/cameras#index"

  namespace :cct_nvr_db do
    resources :cameras do
      collection do

        put  :create
        patch :update
        patch :update_soc

        post :import
        get  :create_database_index
        get  :show_cam_info
        get  :show_cam_info_index
        get  :show_soc_info
        get  :show_soc_info_index


        get  :new_and_update_cam_info_index
        get  :new_cam_info_index
        post  :new_cam_info_index

        patch :new_cam_info


        post :update_cam_info_index
        get  :update_cam_info_index
        patch  :update_success
        get  :update_cam_info

        post :test_update
        patch :test_update

        get  :update_cam_other_info_index
        get  :update_cam_other_info

        # post :create_other_info
        post :create_camera_other_info

        get  :export_csv_index

        # post  :update_cam_info_index
        # post  :update_cam_info
        # patch :update_cam_info
      end
    end
  end

  namespace :cct_nvr_db do
    resources :camera_other_infos do
      collection do
        post :import
        get  :import_success
        get  :import_fail
      end
    end
  end


  namespace :cct_nvr_db do
    resources :test_soc_cameras do
      collection do
        post :import
        get  :import_success
      end
    end

  end

  namespace :cct_nvr_db do
    resources :show_cam_info_and_updates do
      collection do
        post  :import
        get   :import_success
      end
    end
  end

  # root to: "cameras#index"


  get 'welcome/test_index/index' => 'welcome/test_index#index'

  root to: "welcome/index#index"




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
