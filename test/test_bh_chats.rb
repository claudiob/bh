require_relative 'test_helper'

class TestBhChats < IntegrationCase
  def test_a_chat_is_a_thread_of_bubbles_each_under_who_said_it_and_when
    visit '/'

    assert_includes body, '<div class="chat-thread" data-controller="thread">'
    assert_includes body, '<div class="chat" data-thread-target="messages">'
    # The other side's turn comes in on the left, the reader's goes out on the right.
    assert_includes body, '<small class="chat-aside chat-aside-in">Claude ' \
                          '<time datetime="2026-09-13T12:00:00-04:00" ' \
                          'title="September 13, 2026 12:00">'
    assert_includes body, '<p class="chat-bubble chat-in">Data loaded! What can I help with?</p>'
    assert_includes body, '<strong class="fg-success">✓</strong></small>'
    assert_includes body, '<p class="chat-bubble chat-out">How much did I bill last month?</p>'
    # A turn may carry markup a host rendered, and says what it cost where anything did.
    assert_includes body, '· $0.0123</small>'
    assert_includes body, '<p class="chat-bubble chat-in"><span class="fs-4">$12,400</span></p>'
    # One with no author and no time still says how its delivery went.
    assert_includes body, '<small class="chat-aside chat-aside-out">' \
                          '<strong class="fg-danger">✕</strong></small>'
    # A turn with nothing said yet is being typed.
    assert_includes body, '<p class="chat-bubble chat-in chat-typing" aria-label="Typing">' \
                          '<span></span><span></span><span></span></p>'
    # And a turn saying nothing about itself gets no aside at all.
    refute_includes body, '<small class="chat-aside chat-aside-out"></small>'
  end

  # A picture rides in the bubble under the words, opening full size in a tab of its own:
  # what fits beside words is rarely what somebody wants to look at. A message carrying
  # pictures and nothing else is a message all the same, rather than one being typed.
  def test_a_message_carries_its_pictures_in_the_bubble_under_its_words
    visit '/'

    photo = '<a href="/meter.png" target="_blank" rel="noopener">' \
            '<img src="/meter.png" alt="Photo" class="chat-photo" loading="lazy"></a>'

    assert_includes body, %(<p class="chat-bubble chat-out">Here is the meter\n#{photo}</p>)
    # Two of them in one bubble, with no words over either -- pictures alone are a
    # message, not a message still being typed.
    assert_includes body, '<p class="chat-bubble chat-in"><a href="/reading.png"'
    assert_includes body, '<img src="/dial.png" alt="Photo" class="chat-photo" loading="lazy">'
  end

  # What the thread is about stands over the whole of it rather than in it: nobody said
  # this, and a bubble would claim somebody had.
  def test_a_note_stands_over_the_thread_rather_than_in_it
    visit '/'

    assert_includes body, '<div class="chat-thread" data-controller="thread">' \
                          '<p class="chat-note">About the March invoice</p>'
    # And a thread with nothing to say about itself opens straight onto its messages.
    refute_includes body, '<p class="chat-note"></p>'
  end

  def test_the_field_under_a_thread_posts_the_next_question_and_suggests_what_to_ask
    visit '/'

    assert_includes body, '<form class="d-flex align-items-center" data-controller="require" ' \
                          'data-turbo-action="replace" ' \
                          'action="/questions" accept-charset="UTF-8" method="post">'
    assert_includes body, '<label for="ask" class="visually-hidden">Ask a question</label>'
    assert_includes body, 'id="ask" required="required" autofocus="autofocus" autocomplete="off" ' \
                          'class="form-control rounded-4 flex-grow-1 chat-ask" ' \
                          'placeholder="How much did I bill last month?" ' \
                          'data-thread-target="field" data-turbo-permanent="" ' \
                          'data-controller="placeholder" ' \
                          'data-placeholder-questions-value="' \
                          '[&quot;How much did I bill last month?&quot;,' \
                          '&quot;Which ZIP codes book me most?&quot;]"'
    assert_includes body, '<input type="submit" name="commit" value="Send" ' \
                          'class="btn btn-solid rounded-3 theme-primary ms-3" ' \
                          'data-disable-with="Send" />'
    # One suggestion or none is nothing to cycle through.
    assert_includes body, 'class="form-control rounded-4 flex-grow-1 chat-ask" ' \
                          'data-thread-target="field" data-turbo-permanent="" />'
    # Two chats' forms, and the page's other two beside them.
    assert_equal 4, body.scan('<form').size
  end
end
