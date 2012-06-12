module EasyBackup
  module Adapter
    module Frequency
      class Day
        attr_reader :hour, :minute, :second

        def at(time)
          @hour, @minute, @second = "#{time}:00:00".split(':').map(&:to_i)
        end
      end
    end
  end
end
