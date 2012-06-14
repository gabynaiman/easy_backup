module EasyBackup
  module Schedule
    class Cron
      attr_accessor :logger

      def initialize(timer=nil, &block)
        @logger = Logger.new $stdout
        @schedule = []
        @timer = timer || Timer.new(1.minute)
        @timer.on_tick { wakeup }
        instance_eval &block if block_given?
      end

      def start
        logger.debug "[Cron] Starting (#{Time.now})..."
        @timer.start
      end

      def stop
        logger.debug '[Cron] Stopping!'
        @timer.stop
      end

      def running?
        @timer.running
      end

      def wakeup
        @schedule.select { |s| s[:time] <= Time.now }.each do |s|
          s[:block].call
          @schedule.delete s
        end
      end

      def at(time, &block)
        @schedule << {
            :time => time,
            :block => block
        }
      end

    end
  end
end