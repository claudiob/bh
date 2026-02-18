module Bh
  module BootstrapHelpers
    def head_tags
      <<~HEAD.html_safe
        <meta name='viewport' content='width=device-width,initial-scale=1'>
        <meta name='view-transition' content='same-origin'>
        <meta name='turbo-refresh-method' content='morph'>
        <meta name='turbo-refresh-scroll' content='preserve'>
        <meta name='apple-mobile-web-app-capable' content='yes'>
        <meta name='mobile-web-app-capable' content='yes'>
        <meta name='color-scheme' content='light dark'>
        #{csrf_meta_tags}
        #{csp_meta_tag}
        <script async src="https://ga.jspm.io/npm:es-module-shims@1.8.2/dist/es-module-shims.js" data-turbo-track="reload"></script>
        #{javascript_importmap_tags}
        <link rel='icon' href="/favicon#{'-dev' if Rails.env.development?}.png" type='image/png'>
        <link rel="apple-touch-icon" href="/apple-touch-icon.png">
        <link href='https://assets.houseaccount.com/css/bootstrap.min.css' rel='stylesheet'>
        <!-- once it's live: <link href="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-VuYVTUAUbEW1A1EgqVmiLTxfqmvVgsV8yG3KeYZmz8aLednYx2pzlYdT4NS041oo" crossorigin="anonymous"> -->
        #{stylesheet_link_tag :app, 'data-turbo-track': 'reload'}
        #{stylesheet_link_tag :bh, 'data-turbo-track': 'reload'}
      HEAD
    end

    def script_tags
      <<~SCRIPTS.html_safe
        <script src='https://assets.houseaccount.com/js/bootstrap.bundle.min.js'></script>
        <!-- once it's live: <script src="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha1/dist/js/bootstrap.bundle.min.js" integrity="sha384-kBqjI9J+3T2+popvAtxRzS3v5xO7BkyKlAyF/GZgnB0kZ2HoQdx6V1I/EX8ljPWj" crossorigin="anonymous"></script> -->
      SCRIPTS
    end

    def navbar(options = {}, &block)
      tag.div class: 'mb-4 border-bottom shadow-sm' do
        tag.nav class: 'navbar navbar-expand-lg' do
          tag.div **options, &block
        end
      end
    end

    def navbar_brand(brand)
      tag.div brand, class: 'navbar-brand', data: { controller: 'bh--theme', action: 'dblclick->bh--theme#toggle' }
    end

    def card(tabs:, &block)
      tag.div class: 'card' do
        safe_join [card_header(tabs: tabs), card_body(&block)]
      end
    end

    def nav(pills:)
      tag.ul pills, class:'nav nav-pills border-bottom pb-3 mb-3'
    end

    def navbar_nav(&block)
      tag.ul class: 'nav navbar-nav me-auto', &block
    end

    # @return [String] wraps link_to into a nav-item tab.
    def nav_link_to(name, options, &block)
      options.merge! nav_link_options_for(options) if block_given?
      tag.li(class: 'nav-item') { link_to name, options, nav_link_options_for(options), &block }
    end

    def nav_link_options_for(path)
      if current_page?(path) # request.path.starts_with? path
        { class: 'nav-link active', aria: { current: :page } }
      else
        { class: 'nav-link' }
      end
    end

    def navbar_collapsable(&block)
      safe_join [navbar_toggler, navbar_collapse(&block)]
    end

    def navbar_toggler
      tag.button class: 'navbar-toggler', type: 'button', data: {'bs-toggle': 'collapse', 'bs-target': '#navbarSupportedContent'}, aria: {controls: 'navbarSupportedContent', expanded: 'false', label: 'Toggle navigation'} do
        tag.span nil, class: 'navbar-toggler-icon'
      end
    end

    def navbar_collapse(&block)
      tag.div class: 'collapse navbar-collapse', id: 'navbarSupportedContent', &block
    end

    def table(items:, empty_label:, positioned: false, cached: true, headers: [], pagy: nil, &block)
      render 'bh/table', items: items, empty_label: empty_label, positioned: positioned, cached: cached, headers: headers, pagy: pagy, &block
    end

    # Renders the block inside a grid row.
    def grid_row(&block)
      tag.div class: 'row p-2 border-bottom border-subtle', &block
    end

    # Renders key and value next to each other inside a grid row.
    def grid_column(key, value)
      left = tag.div key, class: 'col-3 p-2 fst-italic'
      right = tag.div value, class: 'col p-2'
      safe_join [ left, right ]
    end

    def grid(item:, cached: true, &block)
      render 'bh/grid', item: item, cached: cached, &block
    end

    # Returns a link_to that opens the link outside of the current turbo frame.
    # @note Helpful for links within an administered/table that uses +turbo_action: :advance+.
    def turbo_link_to(name, options, html_options = {})
      link_to name, options, html_options.merge(data: { turbo_frame: '_top' })
    end

    # Display a link with an emoji to edit a resource inside a table.
    def edit_link_to(path)
      tag.td class: 'text-center', style: 'width: 40px' do
        turbo_link_to '➡️', path, class: 'text-decoration-none'
      end
    end

  private

    def card_header(tabs:)
      tag.div class:'card-header' do
        tag.ul tabs, class: 'nav nav-tabs card-header-tabs'
      end
    end

    def card_body(&block)
      tag.div class: 'card-body card-row py-4', &block
    end
  end
end