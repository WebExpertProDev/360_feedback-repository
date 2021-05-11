Rails.application.routes.draw do
  authenticated :user, ->(user) { user.admin? } do
    root 'admin_panel#index'
  end
  authenticated :user, ->(user) { !user.admin? } do
    # root 'user_panel#index'
  end
  root to: 'home#index'
  get '/dashboard',to: "user_panel#index", as: :user_panel
  get 'profile',to: "user_panel#profile",as: :profile
  get 'top_up',to: "user_panel#top_up",as: :top_up
  get 'invites',to: "user_panel#invites",as: :user_invites
  

  resources :leadership_surveys,only: [:new,:create] do
    resources :logbooks
    resources :responses,:controller => "submissions",only: [:new,:create]
    get 'summary'
  end

  resources :responses,:controller => "submissions",except: [:new,:create] do
    get :results
  end
  

  post 'start_survey',to: "leadership_surveys#start_survey",as: :start_survey
  get 'leadership_assessment/:id',to: "leadership_surveys#leadership_survey",as: :user_survey
  
  # get 'leadership_assessment/:id/results',to: "leadership_surveys#leadership_results",as: :user_survey_results
  
  get 'leadership_assessment/:id/invitees',to: "leadership_surveys#invitees",as: :survey_invitees
  get 'leadership_assessments',to: "leadership_surveys#leadership_tests",as: :user_tests
  post 'invite_user',to: "leadership_surveys#invite_user", as: :invite_user
  delete '/users/:id/destroy', to: 'leadership_surveys#destroy', as: :destroy_test

  # get 'payment',to: "user_panel#payment",as: :payment
  post 'payment',to: "user_panel#payment",as: :payment

  get 'admin_panel',to: 'admin_panel#index',as: :admin_panel
  get 'admin_panel/users',as: :admin_users
  get 'admin_panel/questionnaires',as: :admin_questionnaires
  get 'admin_panel/edit_intro',as: :admin_edit_intro
  post 'edit_intro',to: "admin_panel#edit_intro_save",as: :admin_edit_intro_save

  devise_for :users,:controllers => { sessions: 'users/sessions',registrations: 'users/registrations',passwords: 'users/passwords',invitations: 'users/invitations', omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:edit,:update]

  # get 'personal_logbook', to: 'users#logbook',as: :logbook
  # put 'personal_logbook', to: 'users#save_logbook',as: :save_logbook

  post 'stripe-webhooks',to: 'home#webhooks'

  root 'home#index'
  get 'design', to: 'home#design', as: 'design'

  # Excel Upload Feature
  post '/bulk_users', to: 'admin_panel#bulk_users_upload',
                      as: :bulk_users_upload

  # Payment Feature
  resources :variables

  # Locale Handling
  # scope ':locale', locale: /#{I18n.available_locales.join("|")}/ do
    # Questionnaires
    resources :questionnaires
    # Dimensions
    resources :dimensions
    # Questions
    resources :questions
  # end
  # get '*path', to: redirect("/#{I18n.default_locale}/%{path}")
  # get '', to: redirect("/#{I18n.default_locale}")
end
