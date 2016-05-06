Gem::Specification.new do |s|
  s.name = 'handle-rest'
  s.version = '0.0.0'
  s.date = '2016-05-06'
  s.summary = 'Ruby interface to CNRI Handle REST API'

  s.description = %( Ruby interface to the CNRI Handle REST API.
                     The CNRI Handle Server provides a DNS-like method
                     of providing persistent URLs to resources.
                     The REST API is available from Handle Server 8.0
                     onwards. )

  s.authors = ['Aaron Elkiss']
  s.email = 'aelkiss@umich.edu'
  s.files = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.homepage = 'https://github.com/mlibrary/handle-rest'
  s.license = 'APACHE2'
  s.add_dependency 'faraday'

  s.add_development_dependency 'rspec', '~> 3.4'
end
