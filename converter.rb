require 'minitest/autorun'

class Converter
  attr_reader :numeral

  DECIMAL_TO_ROMAN = [
    [1000, 'M'],
    [900, 'CM'],
    [500, 'D'],
    [400, 'CD'],
    [100, 'C'],
    [90, 'XC'],
    [50, 'L'],
    [40, 'XL'],
    [10, 'X'],
    [9, 'IX'],
    [5, 'V'],
    [4, 'IV'],
    [1, 'I']
  ]

  ROMAN_TO_DECIMAL = {
    'M' => 1000,
    'D' => 500,
    'C' => 100,
    'L' => 50,
    'X' => 10,
    'V' => 5,
    'I' => 1
  }


  def decimal_to_roman
    remaining_to_convert = numeral
    roman_numeral = ""
    DECIMAL_TO_ROMAN.each_with_index do |conversion_information, index|
      decimal = conversion_information[0]
      roman = conversion_information[1]

      consecutive_letters = remaining_to_convert / decimal
      roman_numeral += roman * consecutive_letters
      remaining_to_convert = remaining_to_convert % decimal
    end
    roman_numeral
  end

  def roman_to_decimal
    decimal_number = 0

    roman_characters = numeral.split('').reverse
    roman_characters.each_with_index do |roman_character, index|
      decimal_value = ROMAN_TO_DECIMAL[roman_character]

      if index == 0
        # no previous_roman_character
        previous_roman_character = roman_character
      else
        previous_roman_character = roman_characters[index - 1]
      end

      previous_decimal_value = ROMAN_TO_DECIMAL[previous_roman_character]

      if decimal_value < previous_decimal_value
        decimal_number -= decimal_value
      else
        decimal_number += decimal_value
      end
    end

    decimal_number
  end

  def initialize(numeral)
    @numeral = numeral
  end

  def convert
    if numeral.is_a?(String)
      return roman_to_decimal
    elsif numeral.is_a?(Integer)
      return decimal_to_roman
    else
      raise "Unrecognized format"
    end
  end
end



class TestConverter < Minitest::Test
  def test_decimal_to_roman
    assert_equal('III', Converter.new(3).decimal_to_roman)
    assert_equal('XXIX', Converter.new(29).decimal_to_roman)
    assert_equal('XXXVIII', Converter.new(38).decimal_to_roman)
    assert_equal('CCXXIII', Converter.new(223).decimal_to_roman)
    assert_equal('MCMXCIX', Converter.new(1999).decimal_to_roman)

    assert_equal('XC', Converter.new(90).decimal_to_roman)
    assert_equal('IV', Converter.new(4).decimal_to_roman)
    assert_equal('IX', Converter.new(9).decimal_to_roman)
    assert_equal('XL', Converter.new(40).decimal_to_roman)
    assert_equal('CD', Converter.new(400).decimal_to_roman)
    assert_equal('CM', Converter.new(900).decimal_to_roman)
  end

  def test_roman_to_decimal
    assert_equal(223, Converter.new('CCXXIII').roman_to_decimal)
    assert_equal(72, Converter.new('LXXII').roman_to_decimal)

    assert_equal(Converter.new('III').roman_to_decimal, 3)
    assert_equal(Converter.new('XXIX').roman_to_decimal, 29)
    assert_equal(Converter.new('XXXVIII').roman_to_decimal, 38)
    assert_equal(Converter.new('CCXXIII').roman_to_decimal, 223)
    assert_equal(Converter.new('MCMXCIX').roman_to_decimal, 1999)

    assert_equal(Converter.new('XC').roman_to_decimal, 90)
    assert_equal(Converter.new('IV').roman_to_decimal, 4)
    assert_equal(Converter.new('IX').roman_to_decimal, 9)
    assert_equal(Converter.new('XL').roman_to_decimal, 40)
    assert_equal(Converter.new('CD').roman_to_decimal, 400)
    assert_equal(Converter.new('CM').roman_to_decimal, 900)
  end

  def test_examples
    assert_equal(3, Converter.new('III').convert)
    assert_equal('XXIX', Converter.new(29).convert)
    assert_equal('XXXVIII', Converter.new(38).convert)
    assert_equal(291, Converter.new('CCXCI').convert)
    assert_equal('MCMXCIX', Converter.new(1999).convert)
  end
end

Converter.new('III').convert # 3
