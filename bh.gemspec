require_relative 'lib/bh/version'

Gem::Specification.new do |spec|
  spec.name = 'bh'
  spec.version = Bh::VERSION
  spec.authors = ['claudiob']
  spec.email = ['claudio@houseaccount.com']

  spec.summary = 'Bootstrap 6 in a Rails app, with the markup already written.'
  spec.description = 'A form builder that dresses every field a page asks for, the ' \
                     'components Bootstrap ships behavior for and no markup — a combobox, ' \
                     'a 6-digit code, a dialog, a toast, a thread of messages — and the one ' \
                     'stylesheet and script that carry them, served by the engine.'
  spec.homepage = 'https://github.com/claudiob/bh'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata['documentation_uri'] = 'https://rubydoc.info/gems/bh'

  # Whatever git tracks, less what only a contributor needs, so nothing untracked leaks in.
  # The sources of the built files stay: a host serves `public/bh/` and never rebuilds it, but
  # a gem layering its own brand over these — the `houseaccount` gem does — bundles the
  # stylesheet and the script into one file of its own, and needs what went into them.
  gemspec = File.basename __FILE__
  contributor_only = %w[bin/ test/ .github/ .gitignore .rubocop.yml node_modules/ Gemfile
                        package-lock.json Rakefile screenshot/]
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) || f.start_with?(*contributor_only)
    end
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'actionview', '>= 8.1' # the helpers build tags and forms with it
  spec.add_dependency 'railties', '>= 8.1' # Rails::Engine, which serves the files and helpers
end
