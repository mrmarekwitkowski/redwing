# frozen_string_literal: true

require_relative 'lib/redwing/version'
homepage = 'https://github.com/mrmarekwitkowski/redwing'

Gem::Specification.new do |s|
  s.name = 'redwing'
  s.version = Redwing::VERSION::STRING
  s.summary = 'Redwing'
  s.description = 'Rails inspired (web) application framework'
  s.authors = ['Marek Witkowski']
  s.email = 'info@marekwitkowski.de'
  s.homepage = homepage
  s.license = 'MIT'

  s.required_ruby_version = '>= 3.4'
  s.required_rubygems_version = '~> 4.0'

  s.metadata = {
    'bug_tracker_uri' => "#{homepage}/issues",
    'homepage_uri' => homepage,
    'source_code_uri' => homepage,
    'rubygems_mfa_required' => 'true'
  }

  s.add_dependency 'activesupport', '~> 8.1', '>= 8.1.3'
  s.add_dependency 'puma', '~> 7.2'
  s.add_dependency 'rack', '~> 3.2', '>= 3.2.5'
  s.add_dependency 'rack-cors', '~> 3.0'
  s.add_dependency 'rackup', '~> 2.3', '>= 2.3.1'
  s.add_dependency 'thor', '~> 1.5'

  # rubocop:disable Gemspec/DevelopmentDependencies
  s.add_development_dependency 'pry', '~> 0.16.0'
  s.add_development_dependency 'rspec', '~> 3.13'
  s.add_development_dependency 'rubocop', '~> 1.86.0'
  # rubocop:enable Gemspec/DevelopmentDependencies

  s.files = Dir['*.md', 'bin/*', 'lib/**/*.rb']
  s.require_path = 'lib'
  s.executables = ['redwing']
end
