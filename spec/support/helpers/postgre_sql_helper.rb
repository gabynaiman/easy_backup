module PostgreSQLHelper

  def self.configuration
    if block_given?
      yield ConfigHelper.get 'postgresql'
    else
      ConfigHelper.get 'postgresql'
    end
  end

  def self.create_db
    configuration do |c|
      conn = Sequel.connect("postgres://#{c['username']}:#{c['password']}@#{c['host']}:#{c['port']}")
      conn.run "CREATE DATABASE #{c['database']} WITH ENCODING='UTF8' CONNECTION LIMIT=-1;"
    end
  end

  def self.drop_db
    configuration do |c|
      conn = Sequel.connect("postgres://#{c['username']}:#{c['password']}@#{c['host']}:#{c['port']}")
      conn.run "DROP DATABASE #{c['database']};"
    end
  end

end