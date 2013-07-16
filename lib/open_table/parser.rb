#require 'iconv'
require 'roo'

module OpenTable
  class Parser
    # Initialize a new snapshot instance
    # @param path [String] path to OpenTable xls spreadsheet
    def initialize(path)
      @path = File.expand_path(path)

      if !File.exists?(@path)
        raise ArgumentError, "File does not exist: #{@path}"
      end
    end

    # Parses rows and returns an array with formatted hashes
    # @return [Array<Hash>]
    def parse
      doc = Roo::Excel.new(@path)
      doc.default_sheet = doc.sheets.first
      results = []

      2.upto(doc.last_row) do |r|
        row = parse_row(doc.row(r))
        keep = block_given? ? yield(row) == true : true
        results << row if keep
      end

      results
    end

    private

    def parse_row(row)
      {
        'metro_name'    => row[0],
        'name'          => row[1],
        'neighborhood'  => row[2],
        'address'       => row[3],
        'city'          => row[4],
        'state'         => row[5],
        'postal_code'   => row[6],
        'phone'         => row[7],
        'restaurant_id' => Integer(row[8]),
        'country'       => row[10]
      }
    end
  end
end