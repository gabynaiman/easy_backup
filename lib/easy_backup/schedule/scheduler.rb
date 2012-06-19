module EasyBackup
  module Schedule
    class Scheduler

      def initialize(interval=1.minute, &block)
        @cron = Cron.new(interval)
        instance_eval &block if block_given?
      end

      def every(time, options={}, &block)
        job = {
            :time => time,
            :options => options,
            :block => block
        }
        cron_next_run job
      end

      def start
        EasyBackup.logger.debug "[Scheduler] Starting (#{Time.now})..."
        @cron.start
      end

      def stop
        EasyBackup.logger.debug '[Scheduler] Stopping!'
        @cron.stop
      end

      private

      def cron_next_run(job)
        if job[:last_cron]
          job[:last_cron] = job[:last_cron] + job[:time]
        else
          if job[:options][:from]
            job[:last_cron] = job[:options][:from] + job[:time]
          else
            job[:last_cron] = Time.now + job[:time]
          end
        end

        if job[:options][:to].nil? || job[:last_cron] < job[:options][:to]
          @cron.at job[:last_cron], lambda { cron_next_run job } do
            job[:block].call
          end
        end
      end

    end
  end
end