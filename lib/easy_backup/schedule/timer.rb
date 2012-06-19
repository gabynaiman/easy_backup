module EasyBackup
  module Schedule
    class Timer
      attr_reader :running

      def initialize(interval, &block)
        @interval = interval
        @block = block if block_given?
        @running = false
      end

      def start
        return if @running
        EasyBackup.logger.debug "[Timer] Starting (#{Time.now})..."
        @running = true
        Thread.new do
          time = Time.now
          while @running
            time += @interval
            sleep([time - Time.now, 0].max)
            EasyBackup.logger.debug "[Timer] Tick: #{Time.now}"
            @block.call if @block
          end
        end
      end

      def stop
        EasyBackup.logger.debug '[Timer] Stopping!'
        @running = false
      end

    end
  end
end