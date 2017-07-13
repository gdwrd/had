require 'pry'
require 'had/version'
require 'had/utils'
require 'had/configuration'
require 'had/collector'
require 'had/formatters'
require 'had/formatters/base'
require 'had/formatters/html'
require 'had/formatters/json'

if defined?(RSpec) && ENV['HAD_RUN'] == '1'
  collector = Had::Collector.new

  RSpec.configure do |config|
    config.after(:each) do |example|

      if defined?(Hanami) && process_example?(self.class.example.metadata, example)
        self_request = self.action rescue false
        self_response = response rescue false
      end

      if defined?(self_request) && self_request && defined?(self_response) && self_response
        begin
          collector.collect(self, example, self_request, self_response)
        rescue Rack::Test::Error
          #
        rescue NameError
          raise $!
        end
      end
    end

    config.after(:suite) do
      if collector.records.size > 0
        collector.sort
        Had::Formatters.process(collector.records)
      end
    end
  end

  def process_example?(meta_data, example)
    !(meta_data[:skip_had] || example.metadata[:skip_had])
  end
end
