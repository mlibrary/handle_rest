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
  # Bundler could not find compatible versions for gem "faraday":
  #   In Gemfile:
  #     faraday (~> 2)
  #
  #     hyrax (= 2.9.5) was resolved to 2.9.5, which depends on
  #       signet was resolved to 0.12.0, which depends on
  #         faraday (~> 0.9)
  s.add_dependency "faraday", "~> 0.9"
  # NOTE: This is the last minor release in the v0.x series, next release will be 1.0 to match Faraday v1.0 release and from then on only fixes will be applied to v0.14.x!
  s.add_dependency "faraday_middleware", "~> 0.14.0"
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
