require 'chronic'

module EasyBackup
  class Frequency
    attr_accessor :interval, :from

    def initialize(interval, options={})
      @interval = interval
      @from = options[:from].is_a?(String) ? Chronic.parse(options[:from]) : options[:from]
    end

  end
end