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
end
