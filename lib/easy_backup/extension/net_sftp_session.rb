module Net
  module SFTP
    class Session
      def mkpath!(path)
        path.split('/').inject(nil) do |previous, relative|
          current = previous ? "#{previous}/#{relative}" : relative
          mkdir! current if dir.glob('.', current).empty?
          current
        end
      end
    end
  end
end