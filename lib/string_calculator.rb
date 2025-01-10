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
    m = lines[0].match(/^\/\/((\[(.+?)\])*|(.))\z/) #//[***][%%] or //;
    delimiter_arr = []
    if m
      if m[3]
        #matches multiple character delimiter //[***][%%]
        lines[0].scan(/\[(.+?)\]/) { |a| delimiter_arr << a[0] }
      elsif m[4]
        #matches single character delimiter
        delimiter_arr << m[4]
      end
    else
      #default delmiter ","
      delimiter_arr << ","
    end
    start = m ? 1 : 0

    num = "-?\\d+(\\.\\d+)?"
    delimiter = delimiter_arr.map! { |a| "(#{Regexp.escape(a)})" }.join("|")
    delimiter = "(#{delimiter})"
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