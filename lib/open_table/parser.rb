# encoding: UTF-8
require "csv"

module OpenTable
  class Parser
    # Initialize a new snapshot instance
    # @param path [String] path to OpenTable xls spreadsheet
    def initialize(path)
      @path = path
    end

    # Parses rows and returns an array with formatted hashes
    # @return [Array<Hash>]
    def parse
      results = []

      CSV.parse(read_data).each do |row|
        row = parse_row(row)
        keep = block_given? ? yield(row) == true : true
        results << row if keep
      end

      results
    end

    private

    def read_data
      if @path =~ /^http/i
        Net::HTTP.get(URI.parse(@path))
      else
        File.read(@path)
      end
    end

    def parse_row(row)
      {
        'metro_name'    => row[0],
        'name'          => row[2],
        'neighborhood'  => row[4],
        'price'         => row[3].count("$"),
        'address'       => row[5],
        'city'          => row[6],
        'state'         => row[7],
        'postal_code'   => row[8],
        'phone'         => row[9],
        'restaurant_id' => Integer(row[1]),
        'country'       => row[10],
        'latitude'      => Float(row[11]),
        'longitude'     => Float(row[12]),
      }
    end
  end
end