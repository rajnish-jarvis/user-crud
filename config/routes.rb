Rails.application.routes.draw do
  resources :users do
    collection do
      get :delete_user_by_selection
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

