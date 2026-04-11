# frozen_string_literal: true

require 'thor'
require_relative 'lib/redwing/version'

class Redwing < Thor
  GEM_NAME = 'redwing'
  GEM_VERSION = ::Redwing::VERSION

  desc 'build', 'build Redwing gem'

  def build
    system("gem build #{GEM_NAME}.gemspec")
  end

  desc 'install', 'install Redwing gem'

  def install
    system("gem install ./#{GEM_NAME}-#{GEM_VERSION}.gem")
  end

  desc 'clean', 'remove Redwing gem'

  def clean
    system('rm *.gem')
  end

  desc 'bump', 'bump gem version (--major, --minor, or --tiny)'

  method_option :major, type: :boolean, desc: 'Bump major version'
  method_option :minor, type: :boolean, desc: 'Bump minor version'
  method_option :tiny, type: :boolean, desc: 'Bump tiny (patch) version'

  def bump
    unless [options[:major], options[:minor], options[:tiny]].one?
      say 'Specify exactly one of --major, --minor, or --tiny', :red
      exit 1
    end

    major, minor, tiny = GEM_VERSION.split('.').map(&:to_i)

    if options[:major]
      major += 1
      minor = 0
      tiny = 0
    elsif options[:minor]
      minor += 1
      tiny = 0
    elsif options[:tiny]
      tiny += 1
    end

    new_version = "#{major}.#{minor}.#{tiny}"
    branch = "release/v#{new_version}"

    unless system("git checkout -b #{branch}")
      say "Failed to create branch #{branch}", :red
      exit 1
    end

    version_file = File.expand_path('lib/redwing/version.rb', __dir__)
    content = File.read(version_file).sub(/VERSION = '[^']+'/, "VERSION = '#{new_version}'")
    File.write(version_file, content)

    say "Bumped #{GEM_VERSION} → #{new_version} on branch #{branch}", :green
  end
end
