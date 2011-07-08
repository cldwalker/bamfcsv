module BAMFCSV
  class Table
    include Enumerable
    def initialize(matrix)
      @headers = matrix.shift
      @matrix = matrix
      @header_map = {}
      @headers.each_with_index do |h, i|
        @header_map[h] = i
      end
      @row_cache = []
    end

    def each
      if block_given?
        @matrix.size.times do |idx|
          yield self[idx]
        end
      end
      self
    end

    def [](idx)
      idx += @matrix.size if idx < 0
      return if idx < 0 || idx >= @matrix.size
      @row_cache[idx] ||= Row.new(@header_map, @matrix[idx])
    end

    def empty?
      @matrix.empty?
    end

    def inspect
      "[#{self.map{|r| r.inspect}.join(", ")}]"
    end

    alias __is_a? is_a?
    def is_a?(other)
      Array == other || __is_a?(other)
    end

    alias __kind_of? kind_of?
    def kind_of?(other)
      Array == other || __kind_of?(other)
    end

    private
    def row_hash(row)
      Hash[@headers.zip(row)]
    end

    class Row
      attr_reader :fields

      def initialize(header_map, fields)
        @header_map = header_map
        @fields = fields
      end

      def headers
        @header_map.keys
      end

      def [](key)
        @fields[@header_map[key]]
      end

      alias __is_a? is_a?
      def is_a?(other)
        Hash == other || __is_a?(other)
      end

      alias __kind_of? kind_of?
      def kind_of?(other)
        Hash == other || __kind_of?(other)
      end

      def inspect
        pairs = []
        headers.each do |h|
          pairs << "#{h.inspect} => #{self[h].inspect}"
        end
        "{#{pairs.join(", ")}}"
      end

    end
  end
end
