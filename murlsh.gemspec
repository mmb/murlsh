# -*- encoding: utf-8 -*-

$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'murlsh/version'

Gem::Specification.new do |s|
  s.name = 'murlsh'
  s.version = Murlsh::VERSION
  s.summary = 'Host your bookmarks or maintain a link blog'
  s.description = s.summary
  s.homepage = 'https://github.com/mmb/murlsh'
  s.authors = ['Matthew M. Boedicker']
  s.email = %w{matthewm@boedicker.org}

  s.required_rubygems_version = '>= 1.3.6'

  %w{
    activerecord
    aws-s3
    bcrypt-ruby
    builder
    htmlentities
    nokogiri
    plumnailer
    postrank-uri
    public_suffix
    push-notify
    rack
    rack-cache
    rack-contrib
    rack-rewrite
    rmagick
    rmail
    tinyatom
    treetop
    twitter
    }.each { |g| s.add_dependency g }

  %w{
    fakeweb
    flog
    rack-test
    rspec
    }.each { |g| s.add_development_dependency g }

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files spec/*`.split("\n")
  s.executables = %w{murlsh}
end
