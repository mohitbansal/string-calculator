require 'byebug'
class StringCalculator
  def add(str)
    sum = 0
    negatives = []
    numbers_from_string(str).each do |n|
      if n < 0
        negatives << n
      elsif n <= 1000
        sum += n
      end
    end
    if negatives.length > 0
      raise "negatives not allowed - #{negatives.join(", ")}"
    end
    sum
  end

  private

  def numbers_from_string(str)
    lines = str.lines.map!(&:chomp)
    return [] if lines.empty?

    #parse delimiter characters
    m = lines[0].match(/^\/\/((\[(.+)\])|(.))\z/)
    delimiter_str = m ? (m[3] || m[4]) : ""
    start = m ? 1 : 0

    num = "-?\\d+(\\.\\d+)?"
    delimiter = "((#{Regexp.escape(delimiter_str)})|,)"
    valid_line_reg = Regexp.new("^(#{num}#{delimiter})*#{num}\\z")
    parse_reg = Regexp.new("(#{num})#{delimiter}?")
    
    arr = []
    lines[start..-1].each do |line|
      next if line.empty?
      if line.match(valid_line_reg)
        line.scan(parse_reg) { |a| arr << a[0].to_f }
      else
        raise "invalid format"
      end
    end


    arr
  end

end