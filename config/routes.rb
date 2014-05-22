Moocs::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope "/:locale" do
    resources :tests
    resources :quizzes do
        match "new_answers", :to => "quizzes#new_answers", :as => "new_answers", :via => [:get, :post, :patch]
        match "solve", :to => "quizzes#solve", :as => "solve", :via => [:get, :post, :patch]
        get 'add_answers', to:'quizzes#add_answers', as: 'add_answers'      
        get 'see_answers', to:'quizzes#see_answers', as: 'see_answers'  
    end
  
    resources :users
    get 'signup', to: 'users#new', as: 'signup'

    resources :sessions
    get 'login', to: 'sessions#new', as: 'login'
    get 'logout', to: 'sessions#destroy', as: 'logout'

    resources :courses do
      get 'tracking', to:'courses#tracking', as: 'tracking'  
      get 'change_state', to:'courses#change_state', as: 'change_state'
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
    get 'join_course/:id', to: 'courses#join_course', as:'join_course'

    resources :resources do
        resources :quizzes do
          match "new_answers", :to => "quizzes#new_answers", :as => "new_answers", :via => [:get, :post, :patch]
          match "solve", :to => "quizzes#solve", :as => "solve", :via => [:get, :post, :patch]
          get 'add_answers', to:'quizzes#add_answers', as: 'add_answers'      
          get 'see_answers', to:'quizzes#see_answers', as: 'see_answers'  
      end
    end

    get 'lastest_courses', to: 'welcome#courses', as: 'lastest_courses'
    get 'lastest_courses/:category', to:'welcome#category', as: 'category'
    get 'search', to:'welcome#search', as: 'search'

    scope '/admin' do
      get "/", to: 'admin#index', as: 'admin' 
      get "users", to: 'admin#users', as: 'admin_users'
      get "courses", to: 'admin#courses', as: 'admin_courses'
      get "resources", to: 'admin#resources', as: 'admin_resources'
      get "feedback", to: 'admin#feedback', as: 'admin_feedback'
    end
  end
  
  match 'feedback', to: 'welcome#feedback', as: 'feedback', via: [:post]
  get '/:locale' => 'welcome#index', as: 'index'
  root 'welcome#index'
end
