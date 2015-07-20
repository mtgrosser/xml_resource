ENV["RAILS_ENV"] = "test"

require 'pathname'

if RUBY_VERSION >= '1.9'
  require 'simplecov'
  SimpleCov.start do
    if artifacts_dir = ENV['CC_BUILD_ARTIFACTS']
      coverage_dir Pathname.new(artifacts_dir).relative_path_from(Pathname.new(SimpleCov.root)).to_s
    end
    add_filter '/test/'
    add_filter 'vendor'
  end

  SimpleCov.at_exit do
    SimpleCov.result.format!
    if result = SimpleCov.result
      File.open(File.join(SimpleCov.coverage_path, 'coverage_percent.txt'), 'w') { |f| f << result.covered_percent.to_s }
    end
  end
end

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'byebug'

require 'active_support/testing/autorun'
require 'active_support/test_case'

ActiveSupport::TestCase.test_order = :random

require 'xml_resource'

require_relative 'models/camelid'
require_relative 'models/camel'
require_relative 'models/contact'
require_relative 'models/dromedary'
require_relative 'models/elephant'
require_relative 'models/item'
require_relative 'models/order'
require_relative 'models/shark'
