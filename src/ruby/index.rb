require 'rubygems'
require 'aws-sdk'

def handler(event:, context:)
  [
    "runtime: #{ENV['AWS_EXECUTION_ENV']}",
    "ruby: #{RUBY_VERSION}",
    "aws-sdk: #{Gem.loaded_specs['aws-sdk'].version}"
  ].join("\n")
end