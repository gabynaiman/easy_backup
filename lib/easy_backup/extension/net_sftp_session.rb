module Net
  module SFTP
    class Session
      def mkpath!(path, options={})
        path.split('/').inject(nil) do |previous, relative|
          current = previous ? "#{previous}/#{relative}" : relative
          mkdir! current, options if dir.glob('.', current).empty?
          current
        end
      end
    end
  end
end