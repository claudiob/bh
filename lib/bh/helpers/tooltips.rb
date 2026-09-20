module Bh
  module Helpers
    # The words an element says on hover, which Bootstrap wires nowhere on its own.
    module Tooltips
      # What an element carries to be given a tooltip: the controller that makes one, and
      # what it says. `bs_title` is the name Bootstrap's own tooltip reads.
      # @param title [String] the words the tooltip says.
      # @param placement [String, nil] which side of the element it opens on.
      # @return [Hash] the `data` an element wearing a tooltip takes.
      def bh_tooltip(title, placement: nil)
        { controller: 'tooltip', bs_placement: placement, bs_title: title }.compact
      end
    end
  end
end
