MANUAL MERGE: config/routes.rb

Find your existing line:

resources :products

Change it to:

resources :products do
  collection do
    get :export
    get :new_import
    post :import
  end
end

This gives you these path helpers (Rails' standard naming for collection
routes, pattern is action_then_resource):
- export_products_path
- new_import_products_path
- import_products_path
