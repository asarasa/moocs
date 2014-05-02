Moocs::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  scope "/:locale" do

    resources :tests
    resources :homeworks
    resources :quizzes do
        match "new_answers", :to => "quizzes#new_answers", :as => "new_answers", :via => [:get, :post, :patch]
        match "solve", :to => "quizzes#solve", :as => "solve", :via => [:get, :post, :patch]
        get 'add_answers', to:'quizzes#add_answers', as: 'add_answers'      
        get 'see_answers', to:'quizzes#see_answers', as: 'see_answers'  
    end
    resources :questionnaires
  
    resources :users
    resources :sessions

    resources :courses do
      get 'tracking', to:'courses#tracking', as: 'tracking'  
      resources :topics do
        resources :messages do
          get 'reply', to:'messages#reply', as: 'reply' 
        end
      end
      resources :lectures do
        resources :lessons do
          get "select_lesson", :to => "lessons#select_lesson", :as => "select_lesson"
        end
        match "change_order", :to => "lessons#change_order", :as => "change_order", :via => [:post]
        match "change_state", :to => "lessons#change_state", :as => "change_state", :via => [:post]
      end
    end

    resources :resources do
        resources :questionnaires
        resources :quizzes do
          match "new_answers", :to => "quizzes#new_answers", :as => "new_answers", :via => [:get, :post, :patch]
          match "solve", :to => "quizzes#solve", :as => "solve", :via => [:get, :post, :patch]
          get 'add_answers', to:'quizzes#add_answers', as: 'add_answers'      
          get 'see_answers', to:'quizzes#see_answers', as: 'see_answers'  
      end
    end
  
    get 'signup', to: 'users#new', as: 'signup'
    get 'show_profile', to: 'users#show', as: 'show_profile'
    get 'edit_profile', to: 'users#edit', as: 'edit_profile'
    get 'login', to: 'sessions#new', as: 'login'
    get 'logout', to: 'sessions#destroy', as: 'logout'


    get 'lastest_users', to: 'welcome#users', as: 'lastest_users'
    get 'lastest_courses', to: 'welcome#courses', as: 'lastest_courses'
    get 'join_course/:id', to: 'courses#join_course', as:'join_course'

    get 'user_courses', to: 'users#user_courses', as: 'user_courses'
    get 'user_resources', to: 'users#user_resources', as:'user_resources'
    get 'user_tests', to: 'users#user_tests', as:'user_tests'
    
    get 'courses/:course_id/lectures/:id/view_resource/:resource_id', to:'lectures#view_resource', as: 'view_resource'
    get 'courses/:course_id/lectures/:id/use_resource/:resource_id', to:'lectures#use_resource', as: 'use_resource'
    get 'courses/:course_id/lectures/:id/del_resource/:resource_id', to:'lectures#delete_resource', as: 'del_resource'

    get 'search', to:'welcome#search', as: 'search'

    scope '/admin' do
      get "/", to: 'admin#index', as: 'admin' 
      get "users", to: 'admin#users', as: 'admin_users'
      get "courses", to: 'admin#courses', as: 'admin_courses'
      get "resources", to: 'admin#resources', as: 'admin_resources'
    end
  end
  
  get '/:locale' => 'welcome#index', as: 'index'
  root 'welcome#index'


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
  #     , :sales
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
