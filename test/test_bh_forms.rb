require_relative 'test_helper'

# What the form builder draws, which is every control a page asks for and no markup of
# a page's own.
class TestBhForms < IntegrationCase
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

    assert_includes body, '<input aria-label="size" class="form-control form-control-lg" ' \
                          'type="number"'
    assert_includes body, '<textarea aria-label="notes" class="form-control form-control-lg"'
    assert_includes body, '<input aria-label="photo" class="form-control form-control-lg" ' \
                          'type="file"'
    assert_includes body, '<select aria-label="state" class="form-control form-control-lg" ' \
                          'name="contact[state]"'
    # A unit is written inside the border, which the wrapper draws and the field goes without.
    assert_includes body, '<div class="form-control form-adorn d-flex">' \
                          '<span class="form-adorn-text">$</span>' \
                          '<input aria-label="fee" min="0" step="0.01" class="form-ghost" ' \
                          'type="number" name="contact[fee]" id="contact_fee" /></div>'
    assert_includes body, '<div class="form-control form-adorn d-flex form-adorn-end">' \
                          '<span class="form-adorn-text">%</span>' \
                          '<input aria-label="rate" class="form-ghost" type="number" ' \
                          'name="contact[rate]" id="contact_rate" /></div>'
    # Rails writes the unticked value as a hidden field first, so the box is not the first child.
    assert_includes body, '<div class="form-field">'
    assert_includes body, '<input class="check" type="checkbox"'
    assert_includes body, '<label for="contact_agreed">I agree to the terms</label>'
    assert_includes body, '<input class="radio" type="radio"'
  end

  def test_a_phone_a_submit_and_a_button_are_dressed_and_a_disabled_one_says_why
    visit '/'

    # What the view passed is kept: its class joins the builder's, its data key sits beside
    # the controller's, and its autocomplete overrides.
    assert_includes body, '<input autocomplete="off" data-controller="phone" ' \
                          'data-action="keydown-&gt;phone#down input-&gt;phone#input" ' \
                          'data-places-target="phone" placeholder="555-555-5555" ' \
                          'aria-label="phone" ' \
                          'class="form-control form-control-lg text-center" type="tel" ' \
                          'name="contact[phone]" id="contact_phone" />'
    assert_includes body, '<input type="submit" name="commit" value="Confirm" ' \
                          'class="btn btn-lg rounded-5 theme-primary btn-solid mt-3 md:mt-4" ' \
                          'data-disable-with="Confirm" />'
    assert_includes body, '<button name="button" type="submit" ' \
                          'class="btn btn-lg rounded-5 theme-primary btn-solid mt-3 md:mt-4">' \
                          '<b>Text</b> us</button>'
    # A disabled button hears no mouse, so the words ride on a wrapper around it.
    assert_includes body, '<span class="d-grid mt-3 md:mt-4" data-controller="tooltip" ' \
                          'data-bs-title="Available soon">' \
                          '<button name="button" type="button" disabled="disabled" ' \
                          'class="btn btn-lg rounded-5 theme-primary btn-outline">Call us</button>'
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
