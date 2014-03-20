Gem::Specification.new do |s|
  s.name        = "sync_bumper"
  s.version     = "0.1.1"
  s.authors      = ["Alexey Dubovskoy"]
  s.email       = "dubovskoy.a@gmail.com"
  s.homepage    = "http://github.com/dubadub/sync_bumper"
  s.summary     = "Bumper to involve Sync callbacks at external Rails App"
  s.description = "Bumper to involve Sync callbacks at external Rails App. Sync turns your Rails partials realtime with automatic updates through Faye"
  s.files       = Dir["{lib}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.add_development_dependency 'rails', '~> 2.3.18'

  s.required_rubygems_version = ">= 1.3.4"
end
