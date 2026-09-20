Rails.application.routes.draw do
  # One page calling every helper, which is all a host of this gem needs to prove it.
  root 'pages#show'
end
