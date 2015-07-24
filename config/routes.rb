Rails.application.routes.draw do

	mount Ckeditor::Engine => '/ckeditor'
	ActiveAdmin.routes(self)
	
	root 'home#index'
	
	################

	# get 'connexion' => 'users#new', as: :login
	# post 'connexion' => 'sessions#create'
	# get 'deconnexion' => 'sessions#destroy', as: :logout

	# get 'auth/:provider/callback' => 'sessions#create'
	# get 'auth/failure' => 'sessions#failure'

	resource :users, only: [:new, :create], path: 'utilisateurs'

	################

	match 'contact' => 'home#contact', via: [:get, :post], as: :contact

	get 'faq' => 'home#faq', as: :faq
	get 'cgu' => 'home#cgu', as: :terms
	get 'confidentialité' => 'home#privacy', as: :privacy
	get 'cgv' => 'home#cgv', as: :cgv
	get 'a-propos' => 'home#about', as: :about

	get 'recherche' => 'home#search', as: :search
	get 'suggestion' => 'home#suggest', as: :suggest

	resources :posts, except: [:create, :destroy], path: 'annonces', path_names: { new: 'nouvelle', edit: 'edition' } do
		member do
			post 'upload'
			post 'remove_media'
			match 'contact', via: [:get, :post]

			get 'phones'
			get 'delete'
		end
	end

	get 'sitemap' => 'sitemap#index'
	get 'opensearch' => 'home#opensearch', as: :opensearch

end
