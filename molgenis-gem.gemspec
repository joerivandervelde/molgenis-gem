#!/usr/bin/ruby

spec = Gem::Specification.new do |s| 
  s.name = "molgenis-gem"
  s.version = "0.0.1"
  s.date = "2009-08-27"
  s.summary = "A Ruby implementation of the interaction of MOLGENIS datamodels (XML) with MyExperiment."
  s.description = "This gem has all the necessary classes to allow MOLGENIS datamodels to be handled by the MyExperiment website."
  
  s.authors = ["Morris Swertz", "Joeri van der Velde"]
  s.email = "m.a.swertz@rug.nl"
  s.homepage = "http://gbic.target.rug.nl/trac/molgenis"
  
  s.files = ["lib/molgenis_dot.rb", "lib/molgenis_model.rb", "lib/molgenis_parser.rb", "README.rdoc", "LICENCE"]
  s.extra_rdoc_files = ["README.rdoc", "LICENCE"]
  s.has_rdoc = true
  
  s.rdoc_options = ["-N", "--tab-width=2", "--main=README.rdoc"]

  s.autorequire = ""
  s.require_paths = ["lib"]
  s.platform = Gem::Platform::RUBY 

  s.add_dependency("libxml-ruby", ">=1.1.3")
  s.add_dependency("rdoc", ">=2.4.3")
  s.add_dependency("darkfish-rdoc", ">=1.1.5")
  s.required_ruby_version = Gem::Requirement.new(">=1.0.1")
  s.rubygems_version = "1.3.5"
  
  s.specification_version = 1 if s.respond_to? :specification_version=
  s.required_rubygems_version = nil if s.respond_to? :required_rubygems_version=
  s.cert_chain = nil  
end
