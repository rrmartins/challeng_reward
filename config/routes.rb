Rails.application.routes.draw do
  namespace :invites do
    resource :calculate, only: :update
  end
end
