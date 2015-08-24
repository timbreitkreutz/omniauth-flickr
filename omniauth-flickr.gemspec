# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omniauth-flickr/version"

Gem::Specification.new do |s|
  s.name        = "omniauth-flickr"
  s.version     = Omniauth::Flickr::VERSION
  s.authors     = ["Tim Breitkreutz"]
  s.email       = ["tim@sbrew.com"]
  s.homepage    = "https://github.com/timbreitkreutz/omniauth-flickr"
  s.summary     = %q{OmniAuth strategy for Flickr}
  s.description = %q{OmniAuth strategy for Flickr}

  s.rubyforge_project = "omniauth-flickr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'omniauth-oauth', '~> 1.0'
  s.add_runtime_dependency 'multi_json', '~> 1.11.0'
  s.add_development_dependency 'rspec', '~> 3.2.0'
  s.add_development_dependency 'webmock', '~> 1.21.0'
  s.add_development_dependency 'rack-test', '~> 0.6.3'
  s.add_development_dependency 'rspec-its', '~> 1.2.0'

  s.license = 'MIT'
end