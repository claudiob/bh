require_relative 'test_helper'

class TestBhComponents < IntegrationCase
  def test_notices_are_the_flash_as_toasts_and_nothing_where_there_is_nothing_to_say
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
    assert_equal 2, body.scan('class="toast fade show').size
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

  def test_a_pin_field_is_one_real_field_the_slots_are_drawn_over
    visit '/'

    assert_includes body, '<div class="otp otp-lg" data-controller="otp" data-bs-otp="true">' \
                          '<input class="otp-input" inputmode="numeric" pattern="[0-9]{6}" ' \
                          'minlength="6" maxlength="6" autocomplete="one-time-code" ' \
                          'required="required" size="6" type="text" ' \
                          'name="contact[pin_confirmation]" id="contact_pin_confirmation" /></div>'
  end

  def test_every_kind_of_field_is_dressed_by_the_builder_rather_than_by_a_page
    visit '/'

    assert_includes body, '<input class="form-control form-control-lg" type="number"'
    assert_includes body, '<textarea class="form-control form-control-lg"'
    assert_includes body, '<select class="form-select form-select-lg" name="contact[state]"'
    # Rails writes the unticked value as a hidden field first, so the box is not the first child.
    assert_includes body, '<div class="form-check">'
    assert_includes body, '<input class="form-check-input" type="checkbox"'
    assert_includes body, '<label class="form-check-label" for="contact_agreed">' \
                          'I agree to the terms</label>'
  end

  def test_a_combobox_is_a_select_the_bundle_searches_in_the_house_s_own_words
    visit '/'

    # rubocop:disable-next Style/FormatStringToken -- the bundle fills these two, not Ruby
    assert_includes body, 'data-controller="combobox" ' \
                          'data-combobox-placeholder-value="Pick a county" ' \
                          'data-combobox-all-value="All" data-clear="Clear" ' \
                          'data-combobox-more-value="%{first} + %{count} more" ' \
                          'data-no-results="Nothing matches that" data-search="Search"'
  end
end
