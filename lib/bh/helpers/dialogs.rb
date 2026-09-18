module Bh
  module Helpers
    # A dialog a page opens from a link, with none of Bootstrap's markup written by hand.
    module Dialogs
      # A link reading `text` and the dialog it opens: headed `title` with an X to close it,
      # holding the block, and closed as well by a footer button reading `okay` — `Okay`
      # unless told otherwise, or none at all for `false`. The two share an id made from the
      # link's own words, so a page needs to invent none; Bootstrap's own `data-bs-toggle`
      # does the opening, and the browser's element brings the backdrop, the focus trap and
      # Esc. Any other option is an attribute of the link.
      def dialog(text, title:, okay: t('bh.okay'), **options, &)
        id = "dialog-#{text.parameterize}"
        data = { **options.fetch(:data, {}), bs_toggle: 'dialog', bs_target: "##{id}" }
        parts = [bh_dialog_header(id, title), tag.div(capture(&), class: 'dialog-body')]
        parts.push bh_dialog_footer(okay) if okay

        safe_join [
          link_to(text, "##{id}", **options, data:),
          tag.dialog(safe_join(parts), class: 'dialog dialog-slide-down', id:,
                                       aria: { labelledby: "#{id}-title" }),
        ]
      end

    private

      def bh_dialog_header(id, title)
        tag.div class: 'dialog-header' do
          heading = tag.h2 title, class: 'dialog-title', id: "#{id}-title"

          safe_join [heading, bh_dialog_close]
        end
      end

      def bh_dialog_close
        tag.button type: 'button', class: 'btn-close ms-auto', data: { bs_dismiss: 'dialog' },
                   aria: { label: t('bh.close') }
      end

      def bh_dialog_footer(okay)
        tag.div class: 'dialog-footer' do
          tag.button okay, type: 'button', class: 'btn btn-solid theme-secondary',
                           data: { bs_dismiss: 'dialog' }
        end
      end
    end
  end
end
