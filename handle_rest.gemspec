Gem::Specification.new do |s|
  s.name = 'handle_rest'
  s.version = '0.0.1'
  s.date = '2016-05-10'
  s.summary = 'Ruby interface to CNRI Handle REST API'

  s.description = %( Ruby interface to the CNRI Handle REST API.
                     The CNRI Handle Server provides a DNS-like method
                     of providing persistent URLs to resources.
                     The REST API is available from Handle Server 8.0
                     onwards. )

  s.authors = ['Aaron Elkiss']
  s.email = 'aelkiss@umich.edu'
  s.files = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.homepage = 'https://github.com/mlibrary/handle_rest'
  s.license = 'APACHE2'
  s.add_dependency 'faraday'
  s.required_ruby_version = '>= 2.1'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.4'
end
