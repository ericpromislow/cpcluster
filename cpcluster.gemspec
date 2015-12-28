Gem::Specification.new do |s|
  # ... (other stuff) ...
  s.name = "cpcluster"
  s.version = "0.0.20"
  s.summary = "A closest-pair clustering engine written in C with Ruby bindings"
  s.files = Dir.glob('lib/**/*.rb') +
            Dir.glob('ext/**/*.{c,h,rb}')
  s.extensions = ['ext/cpcluster/extconf.rb']
  s.email = "eric.promislow@gmail.com"
  s.author = "Eric Promislow"
  s.description = s.summary
  s.homepage = "http://www.bentframe.org/code/cpcluster_cars"

  # ... (other stuff) ...
end
