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
    # 2文字でアラビア数字になるローマ数字のみ抽出
    pair_roman_chars = roman.scan(PAIR_ROMAN_REGEX)
    # 元のローマ数字から除外する
    single_roman_chars = exclude_pairs_roman!(roman, pair_roman_chars).split('')
    convert_single_roman_to_arabic(single_roman_chars) +
      convert_pair_roman_to_arabic(pair_roman_chars)
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

  # @param [String] roman
  # @param [Array] pair_roman_chars
  # @return [String]
  def exclude_pairs_roman!(roman, pair_roman_chars)
    pair_roman_chars.each_with_object(roman) do |r, result|
      result.gsub!(r, '')
    end
  end

  # @param [Array] single_roman_chars
  # @return [Integer]
  def convert_single_roman_to_arabic(single_roman_chars)
    single_roman_chars.inject(0) do |acc, char|
      acc + SINGLE_ROMAN_TO_ARABIC_MAP.fetch(char)
    end
  end

  # @param [Array] pair_roman_chars
  # @return [Integer]
  def convert_pair_roman_to_arabic(pair_roman_chars)
    pair_roman_chars.inject(0) do |acc, char|
      acc + PAIR_ROMAN_TO_ARABIC_MAP.fetch(char)
    end
  end
end
