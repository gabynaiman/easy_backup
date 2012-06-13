module PostgreSQLHelper
  CONFIG_FILE = "#{File.dirname(__FILE__)}/../../config/database.yaml"

  def self.configuration
    if block_given?
      yield YAML.load_file(CONFIG_FILE)['postgresql']
    else
      YAML.load_file(CONFIG_FILE)['postgresql']
    end
  end

  def self.connection
    configuration do |c|
      Sequel.connect("postgres://#{c['username']}:#{c['password']}@#{c['host']}:#{c['port']}/#{c['database']}")
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