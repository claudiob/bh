require_relative 'test_helper'

# The components Bootstrap ships behavior for and no markup.
class TestBhComponents < IntegrationCase
  def test_toasts_are_the_flash_and_nothing_where_there_is_nothing_to_say
    visit '/'

    refute_includes body, 'toast-container'
    visit '/?flash=1'

    assert_includes body, '<div class="toast-container position-fixed bottom-0 end-0 p-3" ' \
                          'data-turbo-temporary="">' \
                          '<div class="toast fade show theme-success" role="alert" ' \
                          'aria-live="assertive" aria-atomic="true" data-controller="toast" ' \
                          'data-action="mouseenter-&gt;toast#stopTimer ' \
                          'mouseleave-&gt;toast#startTimer focusin-&gt;toast#stopTimer ' \
                          'focusout-&gt;toast#startTimer">' \
                          '<div class="toast-header border-0">' \
                          '<span class="me-auto">Blue Crew was updated.</span>' \
                          '<button type="button" class="btn-close" data-bs-dismiss="toast" ' \
                          'aria-label="Close"></button></div>' \
                          '<div class="toast-body d-none"></div></div>'
    assert_includes body, '<div class="toast fade show theme-danger" role="alert"'
    assert_includes body, 'The team could not be reached.'
    # Data another part of a host keeps in the flash is not a message.
    refute_includes body, 'team_1'
    # A host marking what the page is about, and splicing a link into the words it says.
    assert_includes body, '<div class="toast-container position-fixed bottom-0 end-0 p-3" ' \
                          'data-turbo-temporary="" data-written-row-value="row_9">'
    assert_includes body, '<span class="me-auto"><a href="/">Blue Crew was updated.</a></span>'
    assert_equal 4, body.scan('class="toast fade show').size
  end

  def test_a_dialog_is_a_link_and_the_browsers_own_element_sharing_an_id_made_from_the_words
    visit '/'

    id = 'dialog-i-m-not-on-google-business'
    assert_includes body, '<div><a class="small" data-bs-toggle="dialog" ' \
                          "data-bs-target=\"##{id}\" href=\"##{id}\">" \
                          'I’m not on Google Business</a>' \
                          "<dialog class=\"dialog dialog-slide-down\" id=\"#{id}\" " \
                          "aria-labelledby=\"#{id}-title\"><div class=\"dialog-header\">" \
                          "<h2 class=\"dialog-title\" id=\"#{id}-title\">Not a problem</h2>" \
                          '<button type="button" class="btn-close ms-auto" ' \
                          'data-bs-dismiss="dialog" aria-label="Close"></button></div>' \
                          '<div class="dialog-body">' \
                          "\n  We will look your business up ourselves.\n</div>" \
                          '<div class="dialog-footer"><button type="button" ' \
                          'class="btn btn-solid theme-secondary" data-bs-dismiss="dialog">' \
                          'Okay</button></div></dialog></div>'
    # `okay: false` is a dialog with no footer.
    assert_includes body, '<div class="dialog-body">None.</div></dialog>'
  end

  def test_a_button_that_asks_before_it_acts_carries_the_question_on_its_form
    visit '/'

    assert_includes body, %(<form data-turbo-confirm="Sure?\nThis cannot be undone.")
    assert_includes body, 'class="button_to" method="post" action="/integration">'
    assert_includes body, '<button class="btn btn-solid theme-danger" type="submit">' \
                          'Disconnect</button>'
  end
end
