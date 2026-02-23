require_relative 'lib/bh/version'

Gem::Specification.new do |spec|
  spec.name          = "bh"
  spec.version       = Bh::VERSION
  spec.authors       = ["Claudio Baccigalupo"]
  spec.email         = ["claudio@houseaccount.com"]
  spec.description   = %q{Bh - Bootstrap Helpers}
  spec.summary       = %q{Bh provides a set of powerful helpers that
    streamlines the use of Bootstrap components in Rails views.}
  spec.homepage      = "http://github.com/claudiob/bh"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
