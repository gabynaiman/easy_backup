module ConfigHelper
  CONFIG_FILE = "#{File.dirname(__FILE__)}/../../config.yaml"

  def self.get(key)
    YAML.load_file(CONFIG_FILE)[key]
  end
end