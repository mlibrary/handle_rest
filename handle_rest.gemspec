Gem::Specification.new do |s|
  s.name = "handle_rest"
  s.version = "0.0.4"
  s.summary = "Ruby interface to CNRI Handle REST API"

  s.description = %( Ruby interface to the CNRI Handle REST API.
                     The CNRI Handle Server provides a DNS-like method
                     of providing persistent URLs to resources.
                     The REST API is available from Handle Server 8.0
                     onwards. )

  s.authors = ["Aaron Elkiss"]
  s.email = "aelkiss@umich.edu"
  s.files = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  s.homepage = "https://github.com/mlibrary/handle_rest"
  s.license = "APACHE2"

  s.add_dependency "faraday", "~> 1.0"
  s.add_dependency "faraday_middleware", "~> 1.0"
  s.required_ruby_version = ">= 2.6"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "standard" # includes rubocop and rubocop-performance
  s.add_development_dependency "rubocop-rake"
  s.add_development_dependency "rubocop-rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "dotenv"
end
