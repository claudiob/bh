# What every controller of the dummy app inherits, and the name its layout is found by.
class ApplicationController < ActionController::Base
  default_form_builder Bh::FormBuilder
end
