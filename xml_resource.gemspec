$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "xml_resource/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.date        = '2012-08-27'
  s.name        = "xml_resource"
  s.version     = XmlResource::VERSION
  s.authors     = ['Matthias Grosser']
  s.email       = ['mtgrosser@gmx.net']
  s.homepage    = 'http://rubygems.org/gems/xml_resource'
  s.summary     = 'Turn XML into Ruby objects'
  s.description = ''

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "activesupport", "~> 3.1"
  s.add_dependency 'hpricot'

  s.add_development_dependency 'debugger'
end
