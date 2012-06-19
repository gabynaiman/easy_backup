module EasyBackup
  module Schedule
    class Cron
      attr_accessor :logger

      def initialize(interval=1.minute, &block)
        @jobs = []
        @timer = Timer.new(interval) do
          wakeup
        end
        instance_eval &block if block_given?
      end

      def start
        EasyBackup.logger.debug "[Cron] Starting (#{Time.now})..."
        @timer.start
      end

      def stop
        EasyBackup.logger.debug '[Cron] Stopping!'
        @timer.stop
      end

      def running?
        @timer.running
      end

      def at(time, callback=nil, &block)
        @jobs << {
            :time => time,
            :block => block,
            :callback => callback
        }
      end

      private

      def wakeup
        threads = []
        @jobs.select { |job| job[:time] <= Time.now }.each do |job|
          @jobs.delete job
          threads << Thread.new do
            job[:block].call
            job[:callback].call if job[:callback]
          end
        end
        threads.each { |t| t.join }
      end

    end
  end
end