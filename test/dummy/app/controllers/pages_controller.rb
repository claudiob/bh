# The one page of the dummy app.
class PagesController < ApplicationController
  layout 'bh'

  # Draws every helper once, and says three things in the flash where asked to: two
  # messages and one piece of data the toasts must leave alone.
  def show
    return unless params[:flash]

    flash.now[:notice] = 'Blue Crew was updated.'
    flash.now[:alert] = 'The team could not be reached.'
    flash.now[:written] = { 'row' => 'team_1' }
  end
end
