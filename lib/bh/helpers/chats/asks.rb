module Bh
  module Helpers
    module Chats
      # The field under a thread that sends the next question.
      module Asks
        # A solid button in the primary, rounded like the field beside it.
        SEND_CLASSES = 'btn btn-solid rounded-3 theme-primary ms-3'

      private

        # `replace`, so the redirect back to the page the form is on is a page refresh to Turbo
        # — morphed in place, scroll kept — rather than a visit that lands at the top.
        def bh_chat_ask(url, hints)
          data = { controller: 'require', turbo_action: 'replace' }
          form_with url:, class: 'd-flex align-items-center', data: do
            safe_join [
              tag.label(t('bh.ask'), for: 'ask', class: 'visually-hidden'),
              text_field_tag(:ask, nil, **bh_chat_ask_options(hints)),
              submit_tag(t('bh.send'), class: SEND_CLASSES),
            ], "\n"
          end
        end

        def bh_chat_ask_options(hints)
          {
            id: 'ask', required: true, autofocus: true, autocomplete: 'off',
            class: 'form-control rounded-4 flex-grow-1 chat-ask', placeholder: hints.first,
            data: { thread_target: 'field', turbo_permanent: '',
                    **bh_chat_placeholder_data(hints), },
          }
        end

        def bh_chat_placeholder_data(hints)
          return {} if hints.size < 2

          { controller: 'placeholder', placeholder_questions_value: hints.to_json }
        end
      end
    end
  end
end
