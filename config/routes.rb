Datosdemocraticos::Application.routes.draw do

  if Rails.env.production?
    constraints(:host => /^www.datosdemocraticos.com.ar/) do
      root :to => redirect("http://datosdemocraticos.com.ar")
      get '/*path', :to => redirect {|params| "http://datosdemocraticos.com.ar/#{params[:path]}"}
      post '/*path', :to => redirect {|params| "http://datosdemocraticos.com.ar/#{params[:path]}"}
    end
  end
  
  #sitemap
  get "sitemap.xml" => "sitemap#index", as: "sitemap", defaults: { format: "xml" }

  resources :users

  resources :data_collections, :path => :datas do
       resources :data_fields, :path => :fields
  end

  get 'api/v1/:collection/pagina/:page' => 'api#call', as: :api_call_page
  get 'api/v1/:collection' => 'api#call', as: :api_call

  get 'datas/:id/importar-csv' => 'importador#form', as: :importador_csv
  post 'datas/:id/importar-csv' => 'importador#importar'

  get 'datas/clonar/:id' => 'data_collections#clone', as: :clonar_coleccion

  get 'params/provinces', defaults: { format: "json" }
  get 'params/cities', defaults: { format: "json" }

  get 'login' => 'user#login', as: :login_form
  post 'login' => 'user#autenticar', as: :login

  get 'logout' => 'user#logout', as: :logout

  get 'myaccount' => 'user#myaccount', as: :myaccount

  get 'api-info' => 'api#info', as: :api_info

  get 'registracion' => 'user#registracion', as: :registracion_form
  post 'registracion' => 'user#registrar', as: :registracion

  get 'forgot-password' => 'user#forgot_password_form', as: :forgot_password_form
  post 'forgot-password' => 'user#forgot_password', as: :forgot_password

  get 'password-recovery/:id-:hash' => 'user#password_recovery_form', as: :password_recovery_form
  post 'password-recovery' => 'user#password_recovery', as: :password_recovery

  get 'pending-activation' => 'user#register_success', as: :register_success

  get "/activate/:id-:hash"=> 'user#activar', as: :activar

  get 'quienes-somos' => 'index#quienessomos', :as => :quienes_somos
  get 'contacto' => 'index#contacto', :as => :contacto
  post 'contacto' => 'index#contacto_send'
  get 'que-es-open-data-y-open-gov' => 'index#open_data_info', :as => :open_data_info

  get 'admin' => 'admin#index', as: :admin_index
  get 'admin/analytics' => 'analytics#stats', as: :admin_analytics

  get '' => 'index#home', :as => :home
end
