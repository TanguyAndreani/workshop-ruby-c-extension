Gem::Specification.new do |s|
    s.name        = 'workshop-ruby-c-extension'
    s.version     = '0.1.0'
    s.summary     = "A great C extension"
    s.description = "This C extension is the best extension ever."
    s.authors     = ["Tanguy Andreani"]
    s.email       = 'hello@tanguyandreani.me'
    s.homepage    =
    'https://github.com/TanguyAndreani/workshop-ruby-c-extension'
    s.license       = 'MIT'
    
    s.files       = ['ext/extconf.rb', 'ext/hello.c', 'Rakefile', 'Gemfile', 'README.md']
    s.extensions = [
        'ext/extconf.rb'
    ]
  end
  