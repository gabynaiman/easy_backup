# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "easy_backup/version"

Gem::Specification.new do |s|
  s.name        = 'easy_backup'
  s.version     = EasyBackup::VERSION
  s.authors     = ['Gabriel Naiman']
  s.email       = ['gabynaiman@gmail.com']
  s.homepage    = 'https://github.com/gabynaiman/easy_backup'
  s.summary     = 'Simple DSL to program backups'
  s.description = 'Simple DSL to program backups'

  s.rubyforge_project = 'easy_backup'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rubyzip'
  s.add_dependency 'net-sftp'
  s.add_dependency 'rufus-scheduler'
  #s.add_dependency 'activesupport', '>= 3.0.0'
  #s.add_dependency 'i18n'
  #s.add_dependency 'chronic'

  s.add_development_dependency 'json'
  s.add_development_dependency 'sequel'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rspec'
end
