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

  # @param [String] roman
  # @return [Integer]
  def deromanize(roman)
    special_roman = roman.scan(/IV|IX|XL|XC|CD|CM/)
    special_roman.each do |r|
      roman.gsub!(r, '')
    end
    normal_roman = roman
    special_roman_to_arabic_map =
      {
        "IV" => 4, "IX" => 9,
        "XL" => 40, "XC" => 90,
        "CD" => 400, "CM" => 900
      }
    result = special_roman.inject(0) do |acc, r|
      acc + special_roman_to_arabic_map.fetch(r)
    end
    normal_roman_to_arabic_map =
      {
        "I" => 1, "V" => 5, "X" => 10, "L" => 50, "C" => 100, "D" => 500, "M" => 1000
      }
    normal_roman.split('').inject(result) do |acc, r|
      acc + normal_roman_to_arabic_map.fetch(r)
    end
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
