# The dummy's one page in a layout of its own, nested on the gem's.
class FlowsController < ApplicationController
  layout 'flow'

  # Says its words and lets the layout draw the page around them.
  def show; end
end
