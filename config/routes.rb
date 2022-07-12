Rails.application.routes.draw do
  mount Api::Mount => '/api'
  mount GrapeSwaggerRails::Engine => '/swagger'

  namespace :admin, module: :admin do
    root to: 'deals#index'
    resources :deals, only: [:index]
  end

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
end
