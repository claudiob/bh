module Bh
  module Helpers
    # What the flash says, as the toasts every Bh page shows them in.
    module Notices
      # Bootstrap's tone for each key, so a notice and an alert read apart; a key of the
      # host's own reads neutral.
      TONES = { 'notice' => 'theme-success', 'alert' => 'theme-danger' }.freeze

      # The toast controller's hooks: the timed hide stops while a reader hovers or focuses
      # a toast, so a message stays while someone reads it or aims for the X.
      HOLD = 'mouseenter->toast#stopTimer mouseleave->toast#startTimer ' \
             'focusin->toast#stopTimer focusout->toast#startTimer'

      # Every message in the flash as a toast at the bottom right, visible at first paint and
      # gone after a moment or a click. Only messages: a value that is not words is data some
      # other part of a host keeps in the flash, and is not something to show. Nothing at all
      # where there is nothing to say. `data-turbo-temporary`, so a toast born visible does
      # not replay from the page's snapshot on every Back.
      def notices
        messages = flash.to_hash.select { |_, message| message.is_a? String }
        return if messages.empty?

        toasts = messages.map { |key, message| bh_toast key, message }

        tag.div safe_join(toasts), class: 'toast-container position-fixed bottom-0 end-0 p-3',
                                   data: { turbo_temporary: '' }
      end

    private

      def bh_toast(key, message)
        classes = class_names 'toast fade show', TONES.fetch(key, 'theme-primary')
        options = {
          role: 'alert', aria: { live: 'assertive', atomic: true },
          data: { controller: 'toast', action: HOLD },
        }

        tag.div class: classes, **options do
          safe_join [bh_toast_header(message), tag.div(class: 'toast-body d-none')]
        end
      end

      def bh_toast_header(message)
        tag.div class: 'toast-header border-0' do
          safe_join [tag.span(message, class: 'me-auto'), bh_toast_close]
        end
      end

      def bh_toast_close
        tag.button type: 'button', class: 'btn-close', data: { bs_dismiss: 'toast' },
                   aria: { label: t('bh.close') }
      end
    end
  end
end
