Gem::Specification.new do |s|
  s.name               = "bgg_api"
  s.version            = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcello Missiroli"]
  s.date = %q{2013-01-13}
  s.description = %q{A simple library to easily access the Boardgamess Geek site in a SAAS way}
  s.files = ["lib/bgg_api.rb"]
  s.test_files = ["rspec/*"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Retreive BGG info}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
