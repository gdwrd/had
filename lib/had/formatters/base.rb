module Had
  module Formatters
    class Base
      def initialize(records)
        @records = records
        @output_path = Had.configuration.output_path
        @logger = Had.logger
      end
      attr_reader :logger, :output_path, :records

      def process
        cleanup
        write
      end

    private

      def write
        raise 'Not Implemented'
      end

      def cleanup_pattern
        '**/*'
      end

      def cleanup
        unless Dir.exist?(output_path)
          FileUtils.mkdir_p(output_path)
          logger.info "#{output_path} was recreated"
        end
        FileUtils.rm_rf(Dir.glob("#{output_path}/#{cleanup_pattern}"), secure: true)
      end
    end
  end
end
