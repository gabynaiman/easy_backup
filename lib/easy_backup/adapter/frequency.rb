require 'chronic'

module EasyBackup
  module Adapter
    class Frequency
      attr_accessor :interval, :from, :to

      def initialize(interval, options={})
        @interval = interval
        @from = options[:from].is_a?(String) ? Chronic.parse(options[:from]) : options[:from]
        @to = options[:to].is_a?(String) ? Chronic.parse(options[:to]) : options[:to]
      end

    end
  end
end