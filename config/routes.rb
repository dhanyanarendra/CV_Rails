Rails.application.routes.draw do

  root 'welcome#index'
#Users

# SignUp
post 'api/v1/users' => 'api/v1/users#create'
#SignIn
post "api/v1/authenticate" => 'api/v1/authentications#authenticate'
post "api/v1/authenticate_for_web" => 'api/v1/authentications#authenticate_for_web'
#Index users
get "api/v1/users" => 'api/v1/users#index'
#Show users
get "api/v1/users/:id" => 'api/v1/users#show'
put 'api/v1/users/:id' => 'api/v1/users#update'

#Remove user's profile image
delete 'api/v1/remove_profile_image/:id' => 'api/v1/users#remove_profile_image'

#forgot password
post "api/v1/forgot_password" => 'api/v1/forgot_password#forgot_password'
#Reset_password_api
put "api/v1/reset_password" => 'api/v1/forgot_password#reset_password'

# Campaigns

#Create Campaign
post 'api/v1/user/:id/campaign' => 'api/v1/campaigns#create'
#Index campaigns
get "api/v1/campaigns" => "api/v1/campaigns#index"
#Show campaigns
get "api/v1/users/:id/campaign/:campaign_id" => "api/v1/campaigns#show"
#get campaign for user
get "api/v1/users/:id/get_campaign_for_user" => "api/v1/campaigns#get_campaign_for_user"
#Update Campaign
put 'api/v1/user/:id/campaign/:campaign_id' => 'api/v1/campaigns#update'
#update user with campaign
put 'api/v1/users/:id/campaign/:campaign_id' => 'api/v1/users#update_user_with_campaign'
#delete user with campaign
delete 'api/v1/campaign/:campaign_id' => 'api/v1/campaigns#destroy'



# Feeds

#Create Feeds
post "api/v1/users/:id/campaign/:campaign_id/feed" => "api/v1/feeds#create"
#Index Feeds
get "api/v1/users/:id/campaign/:campaign_id/feeds" => "api/v1/feeds#index"
#Show Feeds
get "api/v1/campaign/:campaign_id/feeds/:id" => "api/v1/feeds#show"

# likeFeeds
post "api/v1/campaign/:campaign_id/feeds/:id/like" => "api/v1/feeds#like_feed"

#issues

post 'api/v1/user/:id/issue' => 'api/v1/issues#create'
get "api/v1/issues" => "api/v1/issues#index"
get "api/v1/users/:id/issues" => "api/v1/issues#get_issues_for_user"
put "api/v1/users/:id/update_issue" => "api/v1/issues#update_issue_to_user"

get 'api/v1/interests' => 'api/v1/interests#index'
post 'api/v1/interest' => 'api/v1/interests#create'

post "api/v1/users/:id/feeds/:feed_id/pledge" => 'api/v1/pledges#pledge_need'
get "api/v1/users/:id/pledges" => 'api/v1/pledges#get_pledges'
put "api/v1/users/:id/feeds/:feed_id/pledges/:pledge_id" => 'api/v1/pledges#update_priority_and_pledge'
get "api/v1/feeds/:id/users" => 'api/v1/feeds#get_all_user_for_particular_feed'

#invite create
post 'api/v1/users/:id/invites' => 'api/v1/invites#create'
get "api/v1/invites/:id" => 'api/v1/invites#get_invitee_details'
get "api/v1/campaign/:id/cordinators" => 'api/v1/users#get_cordinators_for_campaign'
delete "api/v1/user/:id" => 'api/v1/users#destroy'
get "api/v1/invites" => 'api/v1/invites#get_invites'

get "api/v1/get_app_url_for_ios" => "api/v1/users#get_app_url_for_ios"
get "api/v1/get_app_url_for_android" => "api/v1/users#get_app_url_for_android"


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
  #     resources :comments, :sales
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
