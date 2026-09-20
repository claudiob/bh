module Bh
  module Helpers
    # The button that asks before it acts.
    module Confirmations
      # A button whose form is sent only where the question it carries is answered yes.
      # The bundle draws that question as a dialog. Every option is the button's, and the
      # question rides on the form, which is what Turbo asks before submitting either.
      # @param words [String] what the button reads.
      # @param path [String] where the form is sent.
      # @param confirm [String] the question, its first line the title of the dialog.
      # @param options [Hash] anything else the button takes.
      # @return [String] the form and the button in it.
      def bh_confirm_button(words, path, confirm:, **options)
        form = { data: { turbo_confirm: confirm } }.deep_merge options.fetch(:form, {})

        button_to words, path, **options.except(:form), form: form
      end
    end
  end
end
