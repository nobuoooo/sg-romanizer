class SgRomanizer
  ROMAN_STRING_MAP_BY_DIGITS =
    {
      1 => {
        min_roman: "I",
        middle_roman: "V",
        max_roman: "X"
      },
      2 => {
        min_roman: "X",
        middle_roman: "L",
        max_roman: "C"
      },
      3 => {
        min_roman: "C",
        middle_roman: "D",
        max_roman: "M"
      }
    }

  # @param [Integer] arabic
  # @return [String]
  def romanize(arabic)
    arabic.digits.map.with_index do |n, i|
      next if n.zero?

      digit = i + 1
      convert_arabic_to_roman(n, digit)
    end.compact.reverse.join
  end

  def deromanize(roman)
    # write your code here
  end

  private


  # @param [Integer] arabic
  # @param [Integer] digit
  # @return [String]
  def convert_arabic_to_roman(arabic, digit)
    case digit
    when 1, 2, 3
      roman_string = ROMAN_STRING_MAP_BY_DIGITS.fetch(digit)
      min_roman = roman_string[:min_roman]
      middle_roman = roman_string[:middle_roman]
      max_roman = roman_string[:max_roman]
      case arabic
      when 1, 2, 3
        min_roman * arabic
      when 4
        min_roman + middle_roman
      when 5, 6, 7, 8
        middle_roman + (min_roman * (arabic - 5))
      when 9
        min_roman + max_roman
      else
        raise ArgumentError
      end
    when 4
      case arabic
      when 1, 2, 3
        "M" * arabic
      else
        raise ArgumentError
      end
    else
      raise ArgumentError
    end
  end
end
