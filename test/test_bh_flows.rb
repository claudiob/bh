require_relative 'test_helper'

class TestBhFlows < IntegrationCase
  def test_flow_draws_the_page_around_a_card_as_wide_as_the_page_said
    visit '/flow'

    assert_includes body, '<title>Verify your business</title>'
    # What the page stands on is the host's: `flow` takes the header it is handed and every
    # other option as an attribute of the column.
    assert_includes body, "<main class='container-fluid py-4 flex-grow-1 d-flex flex-column'>" \
                          "\n        <div class=\"flow\">" \
                          '<header><a class="fs-4 text-decoration-none" href="/">bh</a></header>'
    assert_includes body, '<h1>Verify your business</h1>' \
                          '<p>We texted a code to 415-555-0000</p>' \
                          '<div class="flow-card p-3 md:p-4 mx-auto" style="--flow-width: 40rem">'
    assert_includes body, '<form action="/verify" accept-charset="UTF-8" method="post">'
    # The form: a fieldset with its legend, a label, a phone field and a submit.
    assert_includes body, '<fieldset class="d-grid flow-fieldset gap-2">' \
                          '<legend>Your code</legend>'
    # Words and a block together wrap the control, which is one cell of a two-column form.
    assert_includes body, '<label for="contact_phone" class="flow-field">' \
                          '<span class="form-label">Mobile number</span>'
    assert_includes body, '<label class="form-label" for="contact_pin_confirmation">' \
                          '6-digit code</label>'
    # What the view passed is kept: its class joins the builder's, its data key sits beside the
    # controller's, and its autocomplete overrides.
    assert_includes body, '<input autocomplete="off" data-controller="phone" ' \
                          'data-action="keydown-&gt;phone#down input-&gt;phone#input" ' \
                          'data-places-target="phone" ' \
                          'class="form-control form-control-lg text-center" type="tel" ' \
                          'name="contact[phone]" id="contact_phone" />'
    assert_includes body, '<input class="otp-input text-center" inputmode="numeric"'
    assert_includes body, '<input type="submit" name="commit" value="Confirm" ' \
                          'class="btn btn-lg rounded-5 theme-primary btn-solid mt-3 md:mt-4" ' \
                          'data-disable-with="Confirm" />'
    assert_includes body, '<button name="button" type="submit" ' \
                          'class="btn btn-lg rounded-5 theme-primary btn-solid mt-3 md:mt-4">' \
                          '<b>Text</b> us</button>'
    # A disabled button with a title says why from a wrapper that hears the mouse for it.
    assert_includes body, '<span class="d-grid mt-3 md:mt-4" data-controller="tooltip" ' \
                          'data-bs-title="Available soon">' \
                          '<button name="button" type="button" disabled="disabled" ' \
                          'class="btn btn-lg rounded-5 theme-primary btn-outline">' \
                          'Call us</button></span>'
    # The foot's pieces, joined by a middot.
    assert_includes body, '</div><footer>' \
                          '<form class="button_to" method="post" action="/integration">'
    assert_includes body, 'Disconnect Jobber</button>'
    assert_includes body, '</form><span class="fg-2" aria-hidden="true">·</span>' \
                          '<form class="button_to" method="post" action="/session">'
    assert_includes body, 'Sign out</button>'
    # A page saying only its title gets no card at all.
    visit '/'

    refute_includes body, 'class="flow"'
  end
end
