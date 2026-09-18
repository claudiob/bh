require_relative 'test_helper'

class TestBhAssets < IntegrationCase
  def test_the_engine_serves_the_built_stylesheet_and_script_under_its_own_prefix
    visit '/bh/css/bh.css'

    # Bootstrap, then the gem's own rules, in one file.
    assert_includes body, '--bs-blue-500'
    assert_includes body, '.chat-bubble'
    assert_includes body, '.recourse-shell'
    # Asked for again on every load: the URL is the same in every version of the gem.
    assert_equal 'no-cache', header('cache-control')
    visit '/bh/js/bh.js'

    assert_includes body, 'register("phone"'
    assert_includes body, 'register("combobox"'
    assert_equal 'no-cache', header('cache-control')
    # A palette is linked one at a time and swapped for another, so the nine are served
    # beside the stylesheet rather than bundled into it.
    visit '/bh/theme/dracula.css'

    assert_includes body, '--bs-white: #f8f8f2;'
    # Bootstrap's own declares nothing: dropping the link is how upstream comes back.
    visit '/bh/theme/bootstrap.css'

    refute_includes body, '--bs-white:'
  end

  def test_the_head_helper_links_what_the_engine_serves
    visit '/'

    assert_includes body, '<link rel="stylesheet" href="/bh/css/bh.css">'
    assert_includes body, '<script type="module" src="/bh/js/bh.js"></script>'
    assert_includes body, '<meta name="turbo-refresh-method" content="morph">'
  end

  def test_the_gem_ships_the_built_files_but_not_their_sources
    files = Gem::Specification.load(File.expand_path('../bh.gemspec', __dir__)).files

    assert_includes files, 'public/bh/css/bh.css'
    assert_includes files, 'public/bh/js/bh.js'
    assert_includes files, 'public/bh/theme/nord.css'
    assert_includes files, 'config/locales/bh.en.yml'
    # And the sources, which the gem layering its own brand over these bundles itself.
    assert_includes files, 'app/stylesheets/bh.css'
    assert_includes files, 'app/javascript/bh.js'
    assert_includes files, 'vendor/bootstrap.min.css'
    refute_includes files, 'Rakefile'
  end
end
