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

  desc 'release_pr', 'trigger a release PR via release-please (runs on GitHub)'

  def release_pr
    system('gh workflow run release-please.yml')
  end

  desc 'publish VERSION', 'trigger gem publish workflow for a given version'

  def publish(version)
    if GEM_VERSION != version
      say "Version mismatch: current is #{GEM_VERSION}, requested #{version}", :red
      exit 1
    end
    system('gh workflow run publish.yml')
  end
end
