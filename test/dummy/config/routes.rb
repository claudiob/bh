Rails.application.routes.draw do
  # One page calling every helper, which is all a host of this gem needs to prove it.
  root 'pages#show'
  # And one page in a layout of the host's own, nested on the gem's.
  resource :flow, only: :show
end
