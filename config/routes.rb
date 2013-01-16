TyneTicketsOrg::Application.routes.draw do
  root :to => 'pages#index'

  get 'features', :controller => 'features', :action => 'index'
end
