require 'bundler/gem_tasks'
require 'minitest/test_task'

Minitest::TestTask.create

require 'rubocop/rake_task'

RuboCop::RakeTask.new

desc 'Build public/css and public/js from their sources, and fail if the result is not committed'
task :assets do
  sh 'npm run build --silent'
  sh 'git diff --exit-code --stat -- public' do |ok, _|
    abort 'public/ differs from its sources: commit the build above' unless ok
  end
end

# Ceiling for every code file, blank and comment lines included.
MAX_FILE_LINES = 100

# Prose, markup, data and artwork are exempt: only Ruby and JavaScript are code here.
EXEMPT_EXTENSIONS = %w[.css .erb .html .ico .jpg .json .md .png .svg .txt .webmanifest
                       .yml].freeze

# Upstream's formatting is not ours to fix, and a built file is as long as what went in.
EXEMPT_DIRECTORIES = %w[vendor/ public/].freeze

desc "Fail if any code file is longer than #{MAX_FILE_LINES} lines"
task :file_length do
  files = `git ls-files -z`.split "\x0"
  code = files.reject do |file|
    EXEMPT_EXTENSIONS.include?(File.extname(file)) ||
      EXEMPT_DIRECTORIES.any? { |directory| file.include? directory }
  end
  too_long = code.select { |file| File.readlines(file).size > MAX_FILE_LINES }

  abort "Longer than #{MAX_FILE_LINES} lines: #{too_long.join ', '}" if too_long.any?
end

task default: %i[assets test rubocop file_length]
