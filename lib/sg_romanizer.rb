class SgRomanizer
  ROMAN_CHARS_MAP_BY_DIGITS =
    {
      1 => { min_base_roman: "I", middle_base_roman: "V", max_base_roman: "X" },
      2 => { min_base_roman: "X", middle_base_roman: "L", max_base_roman: "C" },
      3 => { min_base_roman: "C", middle_base_roman: "D", max_base_roman: "M" }
    }
  PAIR_ROMAN_REGEX = /IV|IX|XL|XC|CD|CM/
  PAIR_ROMAN_TO_ARABIC_MAP =
    { "IV" => 4, "IX" => 9, "XL" => 40, "XC" => 90, "CD" => 400, "CM" => 900 }
  SINGLE_ROMAN_TO_ARABIC_MAP =
    { "I" => 1, "V" => 5, "X" => 10, "L" => 50, "C" => 100, "D" => 500, "M" => 1000 }

  # @param [Integer] arabic
  # @return [String]
  def romanize(arabic)
    arabic.digits.map.with_index do |num, i|
      next if num.zero?

      digit = i + 1
      build_arabic_to_roman(num, digit)
    end.compact.reverse.join # 末尾から計算していたため反転させる
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

  # @param [Integer] num
  # @param [Integer] digit
  # @return [String]
  def build_arabic_to_roman(num, digit)
    case digit
    when 1, 2, 3
      convert_arabic_to_roman_up_to_hundreds(num, digit)
    when 4
      convert_arabic_to_roman_in_thousands(num)
    else
      raise ArgumentError
    end
  end

  # @param [Integer] num
  # @param [Integer] digit
  # @return [String]
  def convert_arabic_to_roman_up_to_hundreds(num, digit)
    roman_chars = ROMAN_CHARS_MAP_BY_DIGITS.fetch(digit)
    # 各桁の基底となるアラビア数字を取得する
    min_base_roman = roman_chars[:min_base_roman]
    middle_base_roman = roman_chars[:middle_base_roman]
    max_base_roman = roman_chars[:max_base_roman]
    case num
    when 1, 2, 3
      min_base_roman * num
    when 4
      min_base_roman + middle_base_roman
    when 5, 6, 7, 8
      middle_base_roman + (min_base_roman * (num - 5))
    when 9
      min_base_roman + max_base_roman
    else
      raise ArgumentError
    end
  end

  # @param [Integer] num
  # @return [String]
  def convert_arabic_to_roman_in_thousands(num)
    case num
    when 1, 2, 3
      "M" * num
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
