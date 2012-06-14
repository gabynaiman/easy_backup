module EasyBackup
  module Schedule
    class Timer
      attr_accessor :logger

      def initialize(interval, &block)
        @interval = interval
        @block = block if block_given?
        @running = false
        @logger = Logger.new $stdout
      end

      def start
        return if @running
        logger.debug "[Timer] Starting (#{Time.now})..."
        @running = true
        Thread.new do
          time = Time.now
          while @running
            time += @interval
            sleep([time - Time.now, 0].max)
            logger.debug "[Timer] Tick: #{Time.now}"
            @block.call if @block
          end
        end
      end

      def stop
        logger.debug '[Timer] Stopping!'
        @running = false
      end

    end
  end
end