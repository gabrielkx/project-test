class Importer::Base
  def initialize(options = {})
    @file = read_file(options[:file])
  end

  def read_file(file)
    JSON.parse(File.read(file))
  rescue JSON::ParserError => e
    raise StandardError, "Invalid JSON file: #{e.message}"
  end

  def process
    raise NotImplementedError, "You must implement the process method"
  end
end
