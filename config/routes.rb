Moocs::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  scope "/:locale" do
    
    match "courses/:course_id/lectures/:lecture_id/change_visibility", :to => "testinlectures#change_visibility", :as => "change_visibility", :via => [ :post]
   
    resources :tests
    resources :quizzes do
        match "new_answers", :to => "quizzes#new_answers", :as => "new_answers", :via => [:get, :post, :patch]
        match "single", :to => "quizzes#single", :as => "single", :via => [:get, :post, :patch]
        match "multi", :to => "quizzes#multi", :as => "multi", :via => [:get, :post, :patch]
        get 'add_answers', to:'quizzes#add_answers', as: 'add_answers'      
        get 'see_answers', to:'quizzes#see_answers', as: 'see_answers'  
    end
  
    resources :questionnaires do
      match "solve", :to => "questionnaires#solve", :as => "solve", :via => [:get, :post, :patch]
    end
    resources :resources
    resources :users
    get 'signup', to: 'users#new', as: 'signup'

    resources :sessions
    get 'login', to: 'sessions#new', as: 'login'
    get 'logout', to: 'sessions#destroy', as: 'logout'

    resources :courses do
      get 'tracking', to:'courses#tracking', as: 'tracking'  
      get 'change_state', to:'courses#change_state', as: 'change_state'
      resources :notices
      resources :topics do
        resources :messages do
          get 'reply', to:'messages#reply', as: 'reply' 
        end
      end

      resources :lectures do
        match "selected_tests", :to => "lectures#selected_tests", :as => "selected_tests", :via => [:get, :post, :patch]
        get 'courses/:course_id/lectures/:id/view_resource/:resource_id', to:'lectures#view_resource', as: 'view_resource'       
        get 'new_quiz', to:'quizzes#new_quiz', as: 'new_quiz'
        resources :scores do
        
        end
        resources :lessons do
          get "select_lesson", :to => "lessons#select_lesson", :as => "select_lesson"
        end
        match "change_order", :to => "lessons#change_order", :as => "change_order", :via => [:post]
        match "change_state", :to => "lessons#change_state", :as => "change_state", :via => [ :post]
      end
    end

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
    get 'join_course/:id', to: 'courses#join_course', as:'join_course'
    
    match "courses/:course_id/lectures/:lecture_id/testinlectures/create", :to => "testinlectures#create", :as => "testinlecture_create", :via => [:get,:post]    
    get 'courses/:course_id/lectures/:lecture_id/testinlecture/:id/solve', :to => 'testinlectures#solve', :as => 'solve'
    match "courses/:course_id/lectures/:lecture_id/testinlectures/:id/solved", :to => "testinlectures#solved", :as => "solved", :via => [:get, :post, :patch]
    match "courses/:course_id/lectures/:lecture_id/testinlectures/:id/delete", :to => "testinlectures#delete", :as => "testinlecture_delete", :via => [:post]

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
